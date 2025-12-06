# Ejemplo de Uso: DFSpec

Este ejemplo muestra como usar DFSpec para implementar una feature de autenticacion.

## 1. Inicializar Proyecto

```bash
# Crear directorio
mkdir mi-app && cd mi-app

# Inicializar Flutter
flutter create .

# Inicializar DFSpec
dfspec init mi-app
```

Resultado:
```
Inicializando proyecto DFSpec: mi-app
=================================
ℹ Creando estructura de directorios...
  + specs
  + specs/features
  + .claude/commands
  + specs/architecture
  + specs/security
  + specs/performance
  + docs/decisions
ℹ Creando archivo de configuracion...
  + dfspec.yaml
ℹ Creando archivos base...
  + specs/README.md
  + specs/features/ejemplo.spec.md

✓ Proyecto inicializado correctamente!
```

## 2. Instalar Comandos Slash

```bash
dfspec install --all
```

Resultado:
```
Instalando comandos slash
=========================
  + df-spec
  + df-plan
  + df-implement
  + df-test
  + df-review
  + df-security
  + df-performance
  + df-docs
  + df-verify
  + df-status
  + df-orchestrate
  + df-deps
  + df-quality

✓ Instalados: 13, Omitidos: 0
```

## 3. Generar Especificacion

```bash
dfspec generate feature "Autenticacion con Google"
```

Resultado:
```
Generando especificacion
========================
Tipo: Especificacion de funcionalidad
Nombre: Autenticacion con Google

✓ Archivo creado: specs/features/autenticacion-con-google.feature.md
```

## 4. Completar Especificacion

Editar `specs/features/autenticacion-con-google.feature.md`:

```markdown
# Especificacion: Autenticacion con Google

> **Version:** 1.0
> **Fecha:** 2024-12-05
> **Autor:** Equipo de Desarrollo

## Resumen

Implementar autenticacion con Google Sign-In para permitir a los usuarios
acceder a la aplicacion usando su cuenta de Google.

## Requisitos Funcionales

### RF-01: Boton de Google Sign-In
- Mostrar boton de "Iniciar sesion con Google"
- Seguir guias de branding de Google

### RF-02: Flujo de Autenticacion
- Iniciar flujo OAuth 2.0
- Obtener tokens de acceso
- Crear/actualizar usuario en backend

### RF-03: Manejo de Sesion
- Persistir sesion entre reinicios
- Implementar refresh token
- Logout limpio

## Criterios de Aceptacion

- [ ] Usuario puede iniciar sesion con Google
- [ ] Sesion persiste al cerrar app
- [ ] Usuario puede cerrar sesion
- [ ] Errores mostrados claramente
```

## 5. Usar Comandos Slash en Claude Code

```
/df-plan Autenticacion con Google
```

Claude generara un plan de implementacion detallado.

```
/df-implement Autenticacion con Google
```

Claude implementara siguiendo TDD estricto.

```
/df-verify Autenticacion con Google
```

Claude verificara la implementacion contra la especificacion.

## 6. Ver Estado del Proyecto

```bash
dfspec agents --info=dftest
```

```
DF Test
=======
ID: dftest
Categoria: Implementacion
Comando: /df-test

Especialista en testing. Genera tests unitarios, de widgets e
integracion con alta cobertura.

Capacidades:
  • Unit testing
  • Widget testing
  • Integration testing
  • Mocking con Mocktail
  • Cobertura de codigo

Herramientas:
  Read, Write, Edit, Bash, Glob
```

## Estructura Final del Proyecto

```
mi-app/
├── dfspec.yaml
├── specs/
│   ├── README.md
│   └── features/
│       └── autenticacion-con-google.feature.md
├── docs/
│   └── decisions/
├── .claude/
│   └── commands/
│       ├── df-spec.md
│       ├── df-plan.md
│       ├── df-implement.md
│       └── ... (13 comandos)
├── lib/
│   └── features/
│       └── auth/
│           ├── domain/
│           ├── data/
│           └── presentation/
└── test/
    └── features/
        └── auth/
```
