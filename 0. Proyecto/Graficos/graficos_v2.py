"""
Modelo biomecánico del brazo humano: Hombro-Codo-Muñeca
Rotación Roll-Pitch-Yaw con cilindro 3D representando el antebrazo
- Plano Z-Y inercial: Plano sagital del cuerpo
- Origen inercial: Hombro
- Origen body: Codo
- Cilindro: Antebrazo (del codo a la muñeca)
"""

import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
from mpl_toolkits.mplot3d.art3d import Poly3DCollection

# ── 1. VALORES NUMERICOS (PARÁMETROS DEL BRAZO) ──────────────────────────────
phi_val   = np.radians(0)   # Roll (rotación del antebrazo sobre su eje)
theta_val = np.radians(0)  # Pitch (flexión/extensión del codo)
psi_val   = np.radians(0)   # Yaw (abducción/aducción del brazo)
g_val     = 9.81
l_brazo   = 0.30            # Longitud del brazo superior (hombro-codo) en metros
l_antebrazo = 0.25          # Longitud del antebrazo (codo-muñeca) en metros
angulo_codo = np.radians(0)   # Ángulo en plano XY del body

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

# Rotación del sistema body (codo) respecto al inercial (hombro)
R_num = Rz(psi_val) @ Ry(theta_val) @ Rx(phi_val)

# ── 3. VECTORES ───────────────────────────────────────────────────────────────
g_inertial = np.array([0, 0, -g_val])  # Gravedad en sistema inercial
g_body_num = R_num.T @ g_inertial      # Gravedad en marco cuerpo (codo)

# Posición del codo respecto al hombro (en sistema inercial)
# Asumiendo que el brazo superior está inicialmente extendido hacia abajo (-Z)
codo_posicion = np.array([0, 0, -l_brazo])

# Vector del antebrazo en el sistema body (codo)
# Apunta en dirección X local (desde codo hacia muñeca)
r_body_num = np.array([l_antebrazo * np.cos(angulo_codo),
                       l_antebrazo * np.sin(angulo_codo), 
                       0])

# Vector del antebrazo rotado al sistema inercial
r_inertial_num = R_num @ r_body_num

# Posición de la muñeca en sistema inercial
muneca_posicion = codo_posicion + r_inertial_num

# Torque generado por la gravedad sobre el antebrazo (en sistema body)
tau_num = np.cross(r_body_num, g_body_num)
tau_inertial_num = R_num @ tau_num
g_body_inertial_num = R_num @ g_body_num

print("=== Modelo Biomecánico del Brazo ===")
print(f"Hombro (origen inercial): [0, 0, 0] m")
print(f"Codo (origen body):       {codo_posicion} m")
print(f"Muñeca:                   {muneca_posicion} m")
print(f"Longitud brazo superior:  {l_brazo} m")
print(f"Longitud antebrazo:       {l_antebrazo} m")
print(f"\ng_body  = {g_body_num}")
print(f"r_body  = {r_body_num}")
print(f"tau     = {tau_num}")
print(f"|g|     = {np.linalg.norm(g_body_num):.4f} m/s^2")

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
fig = plt.figure(figsize=(12, 10), facecolor='white')
ax  = fig.add_subplot(111, projection='3d')
ax.set_facecolor('white')
ax.view_init(elev=20, azim=120)  # Vista que enfatiza el plano sagital (Z-Y)

scale = 0.15  # Escala para los vectores (ajustado a dimensiones del brazo)

# ── 6. BRAZO SUPERIOR (Hombro a Codo) ─────────────────────────────────────────
radio_brazo = 0.04  # Radio del brazo superior (4 cm)
Xb, Yb, Zb = cilindro_orientado([0, 0, 0], codo_posicion, radio_brazo, l_brazo)
ax.plot_surface(Xb, Yb, Zb, alpha=0.4, color='lightcoral',
                edgecolor='none', zorder=2)

# Tapas del brazo superior
dir_brazo = codo_posicion / np.linalg.norm(codo_posicion)
Xtb1, Ytb1, Ztb1 = tapa_cilindro([0, 0, 0], dir_brazo, radio_brazo)
ax.plot_surface(Xtb1, Ytb1, Ztb1, alpha=0.5, color='lightcoral',
                edgecolor='none', zorder=2)
Xtb2, Ytb2, Ztb2 = tapa_cilindro(codo_posicion, -dir_brazo, radio_brazo)
ax.plot_surface(Xtb2, Ytb2, Ztb2, alpha=0.5, color='lightcoral',
                edgecolor='none', zorder=2)

# ── 7. ANTEBRAZO (Codo a Muñeca) ──────────────────────────────────────────────
radio_antebrazo = 0.03  # Radio del antebrazo (3 cm)

# Dirección del antebrazo en sistema inercial
dir_antebrazo = r_inertial_num / np.linalg.norm(r_inertial_num)

# Superficie lateral del antebrazo
Xc, Yc, Zc = cilindro_orientado(codo_posicion, dir_antebrazo, 
                                 radio_antebrazo, l_antebrazo)
ax.plot_surface(Xc, Yc, Zc, alpha=0.5, color='mediumpurple',
                edgecolor='none', zorder=3)

# Tapas del antebrazo
Xt1, Yt1, Zt1 = tapa_cilindro(codo_posicion, dir_antebrazo, radio_antebrazo)
ax.plot_surface(Xt1, Yt1, Zt1, alpha=0.6, color='mediumpurple',
                edgecolor='none', zorder=3)

Xt2, Yt2, Zt2 = tapa_cilindro(muneca_posicion, -dir_antebrazo, radio_antebrazo)
ax.plot_surface(Xt2, Yt2, Zt2, alpha=0.6, color='mediumpurple',
                edgecolor='none', zorder=3)

# Contornos de las tapas del antebrazo
theta_ring = np.linspace(0, 2 * np.pi, 80)
ref_cil = np.array([0, 0, 1]) if abs(dir_antebrazo[2]) < 0.9 else np.array([1, 0, 0])
u_cil   = np.cross(dir_antebrazo, ref_cil); u_cil /= np.linalg.norm(u_cil)
v_cil   = np.cross(dir_antebrazo, u_cil)

# CORRECCIÓN: construir el anillo correctamente
ring_base = codo_posicion + (radio_antebrazo * np.cos(theta_ring)[:, None] * u_cil +
                              radio_antebrazo * np.sin(theta_ring)[:, None] * v_cil)
ring_top  = ring_base + dir_antebrazo * l_antebrazo

ax.plot(ring_base[:, 0], ring_base[:, 1], ring_base[:, 2],
        color='purple', lw=1.2, alpha=0.7)
ax.plot(ring_top[:, 0],  ring_top[:, 1],  ring_top[:, 2],
        color='purple', lw=1.2, alpha=0.7)

# ── 8. ARTICULACIONES (Esferas) ───────────────────────────────────────────────
# Hombro
u_esf = np.linspace(0, 2 * np.pi, 20)
v_esf = np.linspace(0, np.pi, 20)
radio_hombro = 0.05
x_hombro = radio_hombro * np.outer(np.cos(u_esf), np.sin(v_esf))
y_hombro = radio_hombro * np.outer(np.sin(u_esf), np.sin(v_esf))
z_hombro = radio_hombro * np.outer(np.ones(np.size(u_esf)), np.cos(v_esf))
ax.plot_surface(x_hombro, y_hombro, z_hombro, color='darkred', alpha=0.8, zorder=5)

# Codo
radio_codo = 0.045
x_codo = radio_codo * np.outer(np.cos(u_esf), np.sin(v_esf)) + codo_posicion[0]
y_codo = radio_codo * np.outer(np.sin(u_esf), np.sin(v_esf)) + codo_posicion[1]
z_codo = radio_codo * np.outer(np.ones(np.size(u_esf)), np.cos(v_esf)) + codo_posicion[2]
ax.plot_surface(x_codo, y_codo, z_codo, color='darkviolet', alpha=0.8, zorder=5)

# Muñeca
radio_muneca = 0.035
x_muneca = radio_muneca * np.outer(np.cos(u_esf), np.sin(v_esf)) + muneca_posicion[0]
y_muneca = radio_muneca * np.outer(np.sin(u_esf), np.sin(v_esf)) + muneca_posicion[1]
z_muneca = radio_muneca * np.outer(np.ones(np.size(u_esf)), np.cos(v_esf)) + muneca_posicion[2]
ax.plot_surface(x_muneca, y_muneca, z_muneca, color='indigo', alpha=0.8, zorder=5)

# ── 9. EJES INERCIALES (Hombro) ───────────────────────────────────────────────
colores_I = ['r', 'g', 'b']
labels_I  = ['$X_I$', '$Y_I$', '$Z_I$']
for k in range(3):
    d = np.zeros(3); d[k] = scale
    ax.quiver(0, 0, 0, d[0], d[1], d[2],
              color=colores_I[k], linewidth=2.5, arrow_length_ratio=0.15)
    ax.text(d[0]*1.2, d[1]*1.2, d[2]*1.2,
            labels_I[k], fontsize=12, fontweight='bold', color=colores_I[k])

# ── 10. EJES DEL CUERPO (Codo - rotados) ──────────────────────────────────────
colores_B = ['#FF9999', '#55CC55', '#7799FF']
labels_B  = ['$X_B$', '$Y_B$', '$Z_B$']
ejes_B    = R_num @ np.eye(3)
for k in range(3):
    d = ejes_B[:, k] * scale
    origen_codo = codo_posicion
    ax.quiver(origen_codo[0], origen_codo[1], origen_codo[2], 
              d[0], d[1], d[2],
              color=colores_B[k], linewidth=1.8,
              arrow_length_ratio=0.15, linestyle='dashed')
    final = origen_codo + d * 1.2
    ax.text(final[0], final[1], final[2],
            labels_B[k], fontsize=11, color=colores_B[k])

# ── 11. PLANO SAGITAL (Z-Y inercial) ──────────────────────────────────────────
n_pts = 8
yy_sag = np.linspace(-0.2, 0.2, n_pts)
zz_sag = np.linspace(-0.6, 0.1, n_pts)
YY, ZZ = np.meshgrid(yy_sag, zz_sag)
XX = np.zeros_like(YY)  # Plano en X=0

ax.plot_surface(XX, YY, ZZ, alpha=0.08, color='cyan',
                edgecolor='cyan', linewidth=0.3)

# Etiqueta del plano sagital
ax.text(0, 0.22, 0, 'Plano Sagital\n(Z-Y)', 
        fontsize=10, color='darkcyan', ha='center')

# ── 12. VECTOR g INERCIAL ─────────────────────────────────────────────────────
g_n = np.array([0, 0, -1]) * scale
ax.quiver(0, 0, 0, g_n[0], g_n[1], g_n[2],
          color='#555555', linewidth=2, arrow_length_ratio=0.15)
ax.text(g_n[0]*1.2, g_n[1]*1.2, g_n[2]*1.3,
        '$g_I$', fontsize=11, color='#555555')

# ── 13. VECTOR g EN CUERPO (expresado en inercial) ────────────────────────────
g_bn = g_body_inertial_num / g_val * scale
ax.quiver(codo_posicion[0], codo_posicion[1], codo_posicion[2],
          g_bn[0], g_bn[1], g_bn[2],
          color='#D97000', linewidth=2.5, arrow_length_ratio=0.15)
final_gb = codo_posicion + g_bn * 1.2
ax.text(final_gb[0], final_gb[1], final_gb[2],
        '$g_B$', fontsize=11, fontweight='bold', color='#D97000')

# ── 14. VECTOR tau ────────────────────────────────────────────────────────────
if np.linalg.norm(tau_inertial_num) > 1e-6:
    tau_plot = tau_inertial_num / np.linalg.norm(tau_inertial_num) * scale
    ax.quiver(codo_posicion[0], codo_posicion[1], codo_posicion[2],
              tau_plot[0], tau_plot[1], tau_plot[2],
              color='#009999', linewidth=2.5, arrow_length_ratio=0.15)
    final_tau = codo_posicion + tau_plot * 1.15
    ax.text(final_tau[0], final_tau[1], final_tau[2],
            r'$\tau = r \times g$', fontsize=10, fontweight='bold', color='#009999')

# ── 15. LEYENDA Y FORMATO ─────────────────────────────────────────────────────
from matplotlib.lines import Line2D
from matplotlib.patches import Patch

leyenda = [
    Line2D([0],[0], color='r', lw=2.5, label='Sistema inercial (Hombro)'),
    Line2D([0],[0], color='#FF9999', lw=1.8, linestyle='dashed',
           label='Sistema body (Codo)'),
    Patch(facecolor='lightcoral', alpha=0.5, label='Brazo superior'),
    Patch(facecolor='mediumpurple', alpha=0.6, label='Antebrazo'),
    Line2D([0],[0], color='#555555', lw=2, label='$g$ inercial'),
    Line2D([0],[0], color='#D97000', lw=2.5, label='$g$ en cuerpo'),
    Line2D([0],[0], color='#009999', lw=2.5, label=r'$\tau$ (torque)'),
]
ax.legend(handles=leyenda, loc='upper left', fontsize=9, framealpha=0.9)

ax.set_title(
    f'Modelo Biomecánico del Brazo\n'
    f'Roll: $\\phi={np.degrees(phi_val):.0f}°$  |  '
    f'Pitch: $\\theta={np.degrees(theta_val):.0f}°$  |  '
    f'Yaw: $\\psi={np.degrees(psi_val):.0f}°$',
    fontsize=12, fontweight='bold')

ax.set_xlabel('X (lateral)', fontsize=10)
ax.set_ylabel('Y (anteroposterior)', fontsize=10)
ax.set_zlabel('Z (vertical)', fontsize=10)
ax.grid(True, alpha=0.3)

# Ajuste de límites para visualizar todo el brazo
lim = 0.5
ax.set_xlim(-lim, lim)
ax.set_ylim(-lim, lim)
ax.set_zlim(-0.6, 0.2)

# Aspect ratio igual
ax.set_box_aspect([1, 1, 1.2])

plt.tight_layout()
# plt.savefig('/mnt/user-data/outputs/modelo_brazo_biomecánico.png',
#             dpi=200, bbox_inches='tight', facecolor='white')
plt.show()
print("Archivo guardado: modelo_brazo_biomecánico.png")