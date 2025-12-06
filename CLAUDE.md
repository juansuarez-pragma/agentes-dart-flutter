# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Descripcion del Repositorio

Este repositorio contiene un sistema multi-agente (agentes df*) especializado en desarrollo Dart/Flutter. Los agentes estan disenados para trabajar juntos en un pipeline orquestado para planificar, implementar, validar y verificar proyectos Flutter/Dart siguiendo principios de Clean Architecture.

## Catalogo de Agentes

| Agente | Rol | Cuando Usar |
|--------|-----|-------------|
| **dforchestrator** | Orquestador central hibrido | Punto de entrada para solicitudes, clasifica intent, coordina agentes |
| **dfplanner** | Arquitecto de soluciones | Disenar features, planificar arquitectura, elegir state management |
| **dfsolid** | Guardian de calidad | Validar SOLID, YAGNI, DRY, detectar anti-patterns Flutter |
| **dfsecurity** | Guardian de seguridad | Auditar OWASP Mobile Top 10, Platform Channels, seguridad WebView |
| **dfdependencies** | Guardian de dependencias | Prevenir slopsquatting, validar paquetes pub.dev, detectar APIs deprecadas |
| **dfimplementer** | Desarrollador TDD | Escribir codigo con TDD estricto (Red-Green-Refactor), BLoC, Riverpod, Provider |
| **dfdocumentation** | Especialista en documentacion | Auditar Effective Dart docs, detectar anti-patterns, validar README |
| **dfcodequality** | Analista de calidad de codigo | Medir complejidad ciclomatica/cognitiva, detectar code smells |
| **dfperformance** | Auditor de performance | Garantizar 60fps, detectar widget rebuilds, memory leaks, problemas de rendering |
| **dftest** | Especialista en testing | Disenar e implementar tests unitarios, widget, integracion, E2E, golden |
| **dfverifier** | Auditor de completitud | Verificar que implementacion cumple plan, validar criterios de aceptacion |

## Modos de Ejecucion de Agentes

1. **MCP_ONLY**: Invocacion directa de herramienta MCP para tareas operacionales (ejecutar tests, formatear, analizar)
2. **AGENT_SINGLE**: Un agente especializado maneja la solicitud
3. **HYBRID**: Combinacion Agente + MCP
4. **PIPELINE**: Multiples agentes en secuencia (ej: dfplanner → dfsolid → dfimplementer → dfverifier)

## Flujos de Trabajo Clave

### Pipeline Completo para Features
```
dfplanner → dfsolid → dfsecurity || dfdependencies → dfimplementer →
[CP_TDD checkpoint] → dfdocumentation || dfcodequality || dfperformance → dftest → dfverifier
```

### Pipeline de Review (paralelo)
```
dfsecurity || dfsolid || dfcodequality || dfperformance → dfverifier
```

## Principios Core Aplicados

### TDD (Test-Driven Development)
- Los tests DEBEN crearse ANTES del codigo de produccion
- Seguir ciclo Red-Green-Refactor estrictamente
- Cada `lib/src/X.dart` requiere su correspondiente `test/unit/X_test.dart`
- Usar patron AAA (Arrange-Act-Assert) con nombres de tests en espanol

### Clean Architecture
```
lib/
├── src/
│   ├── domain/          # Entidades, interfaces, usecases
│   │   ├── entities/    # Clases inmutables con Equatable
│   │   ├── repositories/# Interfaces abstractas
│   │   └── usecases/    # Logica de negocio extendiendo UseCase<Type, Params>
│   ├── data/            # Implementaciones
│   │   ├── models/      # fromJson, toEntity
│   │   ├── datasources/ # Llamadas a API
│   │   └── repositories/# Implementan interfaces
│   ├── presentation/    # Capa de UI
│   │   ├── contracts/   # DTOs de entrada/salida
│   │   └── adapters/    # Adaptadores de UI
│   ├── core/            # Concerns transversales
│   └── di/              # Inyeccion de dependencias
```

### Manejo de Errores
- Usar `Either<Failure, T>` del paquete dartz para errores esperados
- Las entidades deben ser inmutables con Equatable

## Herramientas MCP Disponibles

Los agentes tienen acceso a estas herramientas MCP:
- `mcp__dart__analyze_files` - Analisis estatico
- `mcp__dart__run_tests` - Ejecutar tests
- `mcp__dart__dart_format` - Formatear codigo
- `mcp__dart__dart_fix` - Aplicar fixes
- `mcp__dart__pub` - Comandos pub (get, add, outdated)
- `mcp__dart__pub_dev_search` - Buscar paquetes en pub.dev

## Checkpoints y Recovery

El orquestador mantiene checkpoints para recuperacion del pipeline:
- **CP_PLAN**: Despues de dfplanner (plan, criterios, arquitectura)
- **CP_DESIGN**: Despues de dfsolid (validacion SOLID)
- **CP_SECURITY**: Despues de dfsecurity (reporte OWASP)
- **CP_TDD**: Despues de dfimplementer (correspondencia 1:1 test-produccion)
- **CP_QUALITY**: Despues de agentes de calidad (metricas, issues)
- **CP_TEST**: Despues de dftest (resultados, cobertura)

## Disparadores de Human Escalation

Los agentes escalan al usuario cuando:
- Se detecta intent ambiguo
- Existen multiples enfoques validos
- El agente falla 2+ veces
- Se encuentra vulnerabilidad critica
- Se requieren modificaciones a la arquitectura
- Se deben agregar nuevas dependencias

## Umbrales de Calidad Clave

| Metrica | Objetivo |
|---------|----------|
| Cobertura de tests | >85% |
| Complejidad ciclomatica (promedio) | <10 |
| Complejidad cognitiva (promedio) | <8 |
| LOC por archivo | <400 |
| LOC por metodo | <40 |
| Frame budget (Flutter) | <16ms |
