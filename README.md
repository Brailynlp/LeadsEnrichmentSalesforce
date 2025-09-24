# LeadsEnrichmentSalesforce


Aplicación en **Salesforce DX** que enriquece automáticamente registros **Lead** mediante una API externa de tipo *enrich*. El flujo (Flow) se encarga de solicitar los datos de la compañía a partir del dominio, guardarlos en Salesforce, y luego un componente JavaScript (LWC) los lee y los muestra.

Este proyecto pone en práctica integración entre Flow, Apex / LWC y servicios externos.

---

## Descripción general

LeadsEnrichmentSalesforce permite que al crear o actualizar un Lead, se envíe el dominio al servicio externo de enriquecimiento, se reciban datos como nombre de empresa, industria, ubicación, etc., y esos datos se almacenen en campos personalizados en el Lead. Luego, un componente en JavaScript (Lightning Web Component) extrae esos datos y los muestra en la interfaz del Lead para que el usuario los vea de forma clara y útil.

Con este enfoque se logra:

- Automatización de enriquecimiento de datos para Leads.  
- Integración entre **Flows**, **Apex / LWC** y APIs externas.  
- Separación clara entre lógica de backend (Flow / Apex) y presentación (JS / LWC).  
- Flexibilidad para adaptar el flujo a múltiples escenarios.

---

## Características

- Envío del dominio del Lead a una API tipo *enrich* para obtener información de la empresa.  
- Flow de Salesforce que llama a Apex o Invocable para interactuar con la API externa.  
- Guardado automático de los datos devueltos en campos del Lead.  
- Componente JavaScript / LWC que recupera esos campos y los presenta al usuario.  
- Manejo de errores y validaciones (por ejemplo, si la API no devuelve datos).  
- Estructura modular y preparada para extensión (otros objetos, otros servicios).  

---

## Tecnologías y herramientas

| Tecnología / Módulo | Rol / Uso |
|----------------------|-----------|
| Salesforce DX (SFDX) | Gestión del proyecto y despliegue |
| Flow / Process Builder / Invocable Apex | Orquestación de lógica de enriquecimiento |
| Apex (clases invocables) | Lógica de integración con la API externa |
| LWC (Lightning Web Component) / JavaScript | Presentación de datos enriquecidos en UI |
| JavaScript / Fetch / Promesas | Lógica cliente para consumir APIs o leer datos de Salesforce |
| Node.js & npm | Dependencias de desarrollo, scripts auxiliares |
| Husky & linter | Asegurar calidad de código pre-commit |

---

## Estructura del repositorio

```bash
LeadsEnrichmentSalesforce/
├── .husky/
├── .vscode/
├── config/
├── force-app/
│   └── main/
│       └── default/
│           ├── classes/         # Apex classes, clases invocables
│           ├── flows/           # Definición de Flow / archivos .flow
│           ├── lwc/             # Componentes Lightning Web Components
│           └── objects/         # Definiciones de objetos / campos
├── manifest/
├── scripts/
├── sfdx-project.json
├── package.json
└── README.md
