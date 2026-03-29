"""
Rotacion Roll-Pitch-Yaw con cilindro 3D
Equivalente al script MATLAB, reemplazando el vector r por un cilindro
de radio 0.5 y largo 25, orientado segun r_body y rotado al marco inercial.
"""

import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
from mpl_toolkits.mplot3d.art3d import Poly3DCollection

# ── 1. VALORES NUMERICOS ──────────────────────────────────────────────────────
phi_val   = np.radians(10)   # Roll
theta_val = np.radians(40)   # Pitch
psi_val   = np.radians(50)   # Yaw
g_val     = 9.81
l_val     = 1.0
alpha_val = np.radians(30)

# ── 2. MATRICES DE ROTACION ───────────────────────────────────────────────────
def Rx(a):
    return np.array([[1,       0,        0],
                     [0, np.cos(a), -np.sin(a)],
                     [0, np.sin(a),  np.cos(a)]])

def Ry(a):
    return np.array([[ np.cos(a), 0, np.sin(a)],
                     [        0,  1,         0],
                     [-np.sin(a), 0, np.cos(a)]])

def Rz(a):
    return np.array([[np.cos(a), -np.sin(a), 0],
                     [np.sin(a),  np.cos(a), 0],
                     [        0,          0, 1]])

R_num = Rz(psi_val) @ Ry(theta_val) @ Rx(phi_val)

# ── 3. VECTORES ───────────────────────────────────────────────────────────────
g_inertial       = np.array([0, 0, -g_val])
g_body_num       = R_num.T @ g_inertial          # gravedad en marco cuerpo
r_body_num       = np.array([l_val * np.cos(alpha_val),
                              l_val * np.sin(alpha_val), 0])
r_inertial_num   = R_num @ r_body_num             # r rotado al inercial

tau_num          = np.cross(r_body_num, g_body_num)
tau_inertial_num = R_num @ tau_num
g_body_inertial_num = R_num @ g_body_num

print("=== Resultados numericos ===")
print(f"g_body          = {g_body_num}")
print(f"r_body          = {r_body_num}")
print(f"tau             = {tau_num}")
print(f"|g|             = {np.linalg.norm(g_body_num):.4f} m/s^2")

# ── 4. FUNCION: CILINDRO ORIENTADO ────────────────────────────────────────────
def cilindro_orientado(origen, direccion, radio, largo, n=40):
    """
    Genera la malla 3D de un cilindro dado origen, vector director,
    radio y largo. Devuelve (X, Y, Z) para plot_surface.
    """
    d = np.array(direccion, dtype=float)
    d /= np.linalg.norm(d)

    # Vector perpendicular al eje
    ref = np.array([0, 0, 1]) if abs(d[2]) < 0.9 else np.array([1, 0, 0])
    u   = np.cross(d, ref); u /= np.linalg.norm(u)
    v   = np.cross(d, u)

    theta_c = np.linspace(0, 2 * np.pi, n)
    t_c     = np.linspace(0, largo, 2)
    Th, T   = np.meshgrid(theta_c, t_c)

    # Puntos de la superficie lateral
    circ = radio * (np.cos(Th)[..., np.newaxis] * u +
                    np.sin(Th)[..., np.newaxis] * v)
    axis = T[..., np.newaxis] * d

    P = np.array(origen) + circ + axis
    return P[..., 0], P[..., 1], P[..., 2]


def tapa_cilindro(origen, direccion, radio, n=40):
    """Genera los puntos de una tapa circular (disco)."""
    d = np.array(direccion, dtype=float)
    d /= np.linalg.norm(d)
    ref = np.array([0, 0, 1]) if abs(d[2]) < 0.9 else np.array([1, 0, 0])
    u   = np.cross(d, ref); u /= np.linalg.norm(u)
    v   = np.cross(d, u)

    theta_c = np.linspace(0, 2 * np.pi, n)
    r_c     = np.linspace(0, radio, 2)
    Th, R_c = np.meshgrid(theta_c, r_c)

    circ = R_c[..., np.newaxis] * (np.cos(Th)[..., np.newaxis] * u +
                                    np.sin(Th)[..., np.newaxis] * v)
    P = np.array(origen) + circ
    return P[..., 0], P[..., 1], P[..., 2]


# ── 5. FIGURA ─────────────────────────────────────────────────────────────────
fig = plt.figure(figsize=(10, 8), facecolor='white')
ax  = fig.add_subplot(111, projection='3d')
ax.set_facecolor('white')
ax.view_init(elev=25, azim=35)

scale = 20.0

# Parámetros del cilindro
radio_cil = 0.5
largo_cil = 25.0

# Dirección del cilindro: r rotado al marco inercial
dir_cil = r_inertial_num / np.linalg.norm(r_inertial_num)

# Superficie lateral
Xc, Yc, Zc = cilindro_orientado([0, 0, 0], dir_cil, radio_cil, largo_cil)
ax.plot_surface(Xc, Yc, Zc, alpha=0.35, color='mediumpurple',
                edgecolor='none', zorder=2)

# Tapas
Xt1, Yt1, Zt1 = tapa_cilindro([0, 0, 0], dir_cil, radio_cil)
ax.plot_surface(Xt1, Yt1, Zt1, alpha=0.4, color='mediumpurple',
                edgecolor='none', zorder=2)

extremo_cil = np.array([0, 0, 0]) + dir_cil * largo_cil
Xt2, Yt2, Zt2 = tapa_cilindro(extremo_cil, -dir_cil, radio_cil)
ax.plot_surface(Xt2, Yt2, Zt2, alpha=0.4, color='mediumpurple',
                edgecolor='none', zorder=2)

# Contornos de las tapas
theta_ring = np.linspace(0, 2 * np.pi, 80)
ref_cil = np.array([0, 0, 1]) if abs(dir_cil[2]) < 0.9 else np.array([1, 0, 0])
u_cil   = np.cross(dir_cil, ref_cil); u_cil /= np.linalg.norm(u_cil)
v_cil   = np.cross(dir_cil, u_cil)

ring_base = (radio_cil * np.cos(theta_ring)[:, None] * u_cil +
             radio_cil * np.sin(theta_ring)[:, None] * v_cil)
ring_top  = ring_base + dir_cil * largo_cil

ax.plot(ring_base[:, 0], ring_base[:, 1], ring_base[:, 2],
        color='purple', lw=1.2, alpha=0.7)
ax.plot(ring_top[:, 0],  ring_top[:, 1],  ring_top[:, 2],
        color='purple', lw=1.2, alpha=0.7)

# ── 6. EJES INERCIALES ────────────────────────────────────────────────────────
colores_I = ['r', 'g', 'b']
labels_I  = ['$X_I$', '$Y_I$', '$Z_I$']
for k in range(3):
    d = np.zeros(3); d[k] = scale
    ax.quiver(0, 0, 0, d[0], d[1], d[2],
              color=colores_I[k], linewidth=2.5, arrow_length_ratio=0.1)
    ax.text(d[0]*1.15, d[1]*1.15, d[2]*1.15,
            labels_I[k], fontsize=12, fontweight='bold', color=colores_I[k])

# ── 7. EJES DEL CUERPO (rotados) ──────────────────────────────────────────────
colores_B = ['#FF9999', '#55CC55', '#7799FF']
labels_B  = ['$X_B$', '$Y_B$', '$Z_B$']
ejes_B    = R_num @ np.eye(3)
for k in range(3):
    d = ejes_B[:, k] * scale
    ax.quiver(0, 0, 0, d[0], d[1], d[2],
              color=colores_B[k], linewidth=1.8,
              arrow_length_ratio=0.1, linestyle='dashed')
    ax.text(d[0]*1.15, d[1]*1.15, d[2]*1.15,
            labels_B[k], fontsize=11, color=colores_B[k])

# ── 8. VECTOR g INERCIAL ──────────────────────────────────────────────────────
g_n = np.array([0, 0, -1]) * scale
ax.quiver(0, 0, 0, g_n[0], g_n[1], g_n[2],
          color='#555555', linewidth=2, arrow_length_ratio=0.15)
ax.text(g_n[0]*1.2, g_n[1]*1.2, g_n[2]*1.2,
        '$g_I$', fontsize=11, color='#555555')

# ── 9. VECTOR g EN CUERPO (expresado en inercial) ─────────────────────────────
g_bn = g_body_inertial_num / g_val * scale
ax.quiver(0, 0, 0, g_bn[0], g_bn[1], g_bn[2],
          color='#D97000', linewidth=2.5, arrow_length_ratio=0.1)
ax.text(g_bn[0]*1.18, g_bn[1]*1.18, g_bn[2]*1.18,
        '$g_B$', fontsize=11, fontweight='bold', color='#D97000')

# ── 10. VECTOR tau ────────────────────────────────────────────────────────────
tau_plot = tau_inertial_num / np.linalg.norm(tau_inertial_num) * scale
ax.quiver(0, 0, 0, tau_plot[0], tau_plot[1], tau_plot[2],
          color='#009999', linewidth=2.5, arrow_length_ratio=0.1)
ax.text(tau_plot[0]*1.12, tau_plot[1]*1.12, tau_plot[2]*1.12 + 0.05,
        r'$\tau = r \times g$', fontsize=11, fontweight='bold', color='#009999')

# ── 11. PLANO XY DEL CUERPO ───────────────────────────────────────────────────
n_pts = 6
uu, vv = np.meshgrid(np.linspace(-0.8, 0.8, n_pts),
                     np.linspace(-0.8, 0.8, n_pts))
pts  = R_num @ np.vstack([uu.ravel(), vv.ravel(), np.zeros(n_pts**2)])
ax.plot_surface(pts[0].reshape(n_pts, n_pts),
                pts[1].reshape(n_pts, n_pts),
                pts[2].reshape(n_pts, n_pts),
                alpha=0.08, color='#6699FF',
                edgecolor='#6699FF', linewidth=0.5)

# ── 12. LEYENDA Y FORMATO ────────────────────────────────────────────────────
from matplotlib.lines import Line2D
from matplotlib.patches import Patch

leyenda = [
    Line2D([0],[0], color='r',       lw=2.5, label='Sistema inercial $(X_I,Y_I,Z_I)$'),
    Line2D([0],[0], color='#FF9999', lw=1.8, linestyle='dashed',
           label='Sistema cuerpo $(X_B,Y_B,Z_B)$'),
    Line2D([0],[0], color='#555555', lw=2,   label='$g$ inercial'),
    Line2D([0],[0], color='#D97000', lw=2.5, label='$g$ en cuerpo'),
    Patch(facecolor='mediumpurple', alpha=0.5,
          label=f'Cilindro  $r={radio_cil}$, $L={largo_cil}$'),
    Line2D([0],[0], color='#009999', lw=2.5,
           label=r'$\tau = r \times g$'),
]
ax.legend(handles=leyenda, loc='upper left', fontsize=9, framealpha=0.85)

ax.set_title(
    f'$\\phi={np.degrees(phi_val):.0f}°$  '
    f'$\\theta={np.degrees(theta_val):.0f}°$  '
    f'$\\psi={np.degrees(psi_val):.0f}°$  |  '
    f'$l={l_val}$  $\\alpha={np.degrees(alpha_val):.0f}°$',
    fontsize=12)
ax.set_xlabel('X'); ax.set_ylabel('Y'); ax.set_zlabel('Z')
ax.grid(True)

# Ajuste de límites para que el cilindro largo sea visible
lim = largo_cil * 0.6
ax.set_xlim(-lim, lim)
ax.set_ylim(-lim, lim)
ax.set_zlim(-lim, lim)

plt.tight_layout()
# plt.savefig('/mnt/user-data/outputs/rotacion_cilindro.png',
#             dpi=150, bbox_inches='tight')
plt.show()
print("Listo — rotacion_cilindro.png guardado.")
