# Outreach Skill

## Description
Generate personalized outreach messages for PISCO and COMARE targets.

## Triggers
- "write outreach for [company]"
- "generate message for [target]"
- "draft email to [company]"
- "create linkedin message for [person]"
- "outreach message for [ICP]"

## ICP Context
When generating messages, use:

### PISCO (Manila Recruitment)
- Service: Filipino hospitality, healthcare, education workers
- Client: Placewell International (50 years, Manila-based)
- Targets: Hotels (Spain/UK), Healthcare (UK), Schools (Asia)
- Language: English for hotels/healthcare, Spanish for Spain schools

### COMARE (Mexico Maintenance)
- Service: B2B maintenance, all trades covered
- Model: Fixed monthly fee per location
- Targets: Pharmacies, restaurants, clinics, gyms, property managers
- Language: Spanish for all Mexico targets
- ICP: 20-200 locations, owner/GM decisions

## Message Templates

### PISCO - Hotels (English)
```
Subject: [Company] + Filipino Hospitality Staff

Hi [Name],

I'm working with Placewell International — a 50-year-old Filipino recruitment agency.

We specialize in placing Filipino hospitality workers in European hotels. They're known for:
• English fluency
• Service mindset  
• EU hotel experience

We're currently working with [similar company] and I'd love to explore a fit for your [location] properties.

15-minute call this week?

Best,
Jordan
```

### PISCO - Hotels (Spanish)
```
Asunto: Personal Filipino para [Hotel]

Hola [Name],

Estoy terminando mi MBA en IE Business School y trabajo con Placewell International, una agencia filipina con 50 años de experiencia.

Buscamos hoteles en España que necesiten personal de hospitaleza. Los trabajadores filipinos son conocidos por inglés fluido y cultura de servicio.

¿Podemos hablar 15 minutos esta semana?

Saludos,
Jordan
```

### COMARE - Pharmacy (Spanish)
```
Asunto: Mantenimiento para [Farmacia]

Hola [Name],

Vi que [Company] tiene [X] ubicaciones en CDMX.

COMARE maneja todo mantenimiento: plomería, eléctrico, HVAC.
Un contrato mensual fijo. Una llamada = resolvemos todo.

¿Tienes 15 minutos esta semana?

Saludos,
Jordan
```

### COMARE - Restaurant (Spanish)
```
Asunto: Mantenimiento para [Restaurant]

Hola [Name],

Noté que [Chain] tiene [X] ubicaciones. El mantenimiento de restaurantes es un dolor de cabeza — emergencias, múltiples proveedores, etc.

COMARE maneja TODO. Un contrato mensual fijo. Una llamada.

¿Te paso un calendario para 15 minutos?

Saludos,
Jordan
```

## Output
- Saves to `/data/workspace/downloads/outreach-YYYY-MM-DD.md`
- Includes decision maker name, company, personalized message, LinkedIn link
- Formats as ready-to-send

## Example usage
"Write outreach for NH Hotel Group"
"Generate message for Spire Healthcare"
"Create LinkedIn message for Javier Estrada"
