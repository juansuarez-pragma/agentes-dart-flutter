# Changelog

Todos los cambios notables de este proyecto se documentan en este archivo.

El formato esta basado en [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/),
y este proyecto adhiere a [Semantic Versioning](https://semver.org/lang/es/).

## [0.1.0] - 2024-12-05

### Agregado

#### CLI Core
- Comando `init` para inicializar proyectos con estructura DFSpec
- Comando `install` para instalar comandos slash en `.claude/commands/`
- Comando `generate` para crear especificaciones desde templates
- Comando `agents` para listar y consultar agentes disponibles
- Flag `--version` para mostrar version
- Flag `--help` en todos los comandos

#### Generadores
- `SpecGenerator` para crear archivos de especificacion
- 6 tipos de especificacion: feature, architecture, security, performance, api, plan
- Templates con placeholders configurables
- Soporte para directorio de salida personalizado

#### Agentes
- Registro de 11 agentes especializados
- Categorias: orchestration, quality, implementation, documentation
- Capacidades y herramientas por agente

#### Comandos Slash
- 13 comandos slash para Claude Code
- Templates con frontmatter y allowed-tools
- Soporte para $ARGUMENTS

#### Templates de Artefactos
- Template de especificacion de feature completo
- Template ADR (Architecture Decision Record)
- Template de requisitos de seguridad (OWASP + STRIDE)
- Template de requisitos de rendimiento (60fps)
- Template de contrato de API
- Template de plan de implementacion TDD

#### Utilidades
- `FileUtils` para operaciones de archivos
- `Logger` para salida de consola con colores
- `DfspecConfig` para configuracion del proyecto

#### Testing
- 121+ tests unitarios
- Tests de integracion para generadores
- Cobertura de todos los comandos

### Configuracion
- Archivo `dfspec.yaml` para configuracion del proyecto
- Linting con `very_good_analysis`
- Soporte para Dart SDK ^3.10.1
