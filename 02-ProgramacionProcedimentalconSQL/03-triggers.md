# Triggers (Disparadores)

## ¿Qué es un trigger?

Es un bloque de código SQL que se ejecuta automáticamente cuando ocurre un eventro en una tabla:

👌 Eventos 

- INSERT
- UPDATE
- DELETE

🐷 No se ejecutan manualmente, se activan solos,

## 🐗 ¿Para que sirven?

- Validaciones
- Auditoria (guardas historial)
- Reglas del negocio
- Automatización

## 🫎 Tipos de Triggers en SQL SERVER

- AFTER TRIGGER

Se ejecuta después del evento

- INSTEAD OF

Remplaza la operación  original


!['image'](./img/)

## 🐙 Sintaxis Básica

```sql
    CREATE TRIGGER nombre_trigger
    ON nombre_tabla
    AFTER INSERT
    AS
    BEGIN
        --  código
    END;
```

## Tablas Especiales 

| Tabla | Contenido |
| :--- | :--- |
| INSERTED | Nuevos Datos |
| DELETED | Datos Anteriores |
