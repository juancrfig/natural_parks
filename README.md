# Natural Parks Management System

## Project Description

This project consists of a database designed to efficiently manage the operations of natural parks under the supervision of the Ministry of the Environment. It includes the administration of departments, parks, areas, species, personnel, research projects, visitors, and accommodations. The solution enables critical queries, automates tasks through triggers and events, and manages user permissions based on predefined roles.

**Main Features**:

- Registration and tracking of parks, areas, and species.
- Personnel management (administration, surveillance, conservation, research).
- Control of research projects and their relation to species.
- Visitor and accommodation management.
- Automatic reports and periodic inventory updates.

***

## System Requirements

- **MySQL Server**: Version 8.0 or higher.
- **MySQL Client**: Recommended MySQL Workbench or DBeaver.
- **Operating System**: Any system compatible with MySQL (Windows, Linux, macOS).

***

## Installation and Configuration

### Steps to set up the database

1. **Create the database**:

   ```sql
   mysql> CREATE DATABASE natural_parks;
   ```

2. **Run the DDL script**:

   ```bash
   mysql -u [user] -p natural_parks < ddl.sql
   ```

3. **Load initial data (DML)**:

   ```bash
   mysql -u [user] -p natural_parks < dml.sql
   ```

4. **Run other scripts**:

   - Queries: `dql_select.sql`
   - Procedures: `dql_procedures.sql`
   - Functions: `dql_functions.sql`
   - Triggers: `dql_triggers.sql`
   - Events: `dql_events.sql`

***

## Database Structure

**Data Model Diagram**:\

**Main Tables**:

- `Department`: Stores departments and their responsible entity.
- `Park`: Registers natural parks with their location and declaration date.
- `Area`: Details areas within each park (name and size).
- `Species`: Contains information on plant, animal, and mineral species.
- `Personnel`: Manages personnel data according to their type (administration, surveillance, etc.).
- `Project`: Registers research projects with budget and dates.
- `Visitor` and `Accommodation`: Manages visitors and their lodging in parks.

***

## Query Examples

### Basic Query

```sql
-- Number of parks per department  
SELECT d.name, COUNT(p.id) AS total_parks  
FROM Department d  
LEFT JOIN Park p ON d.id = p.department_id  
GROUP BY d.name;  
```

### Advanced Query (subquery)

```sql
-- Species with more than 100 individuals in large areas (>500 km²)  
SELECT e.scientific_name, a.name AS area  
FROM Species e  
JOIN Area a ON e.area_id = a.id  
WHERE a.size > 500  
AND e.inventory_number > 100;  
```

***

## Procedures, Functions, Triggers, and Events

### Stored Procedure

#### Register a new park

```sql
CALL sp_register_park('National Park X', '2024-01-01', 3);  
```

### Function

#### Calculate total surface area of a department

```sql
SELECT fn_total_surface_department(3) AS total_surface;  
```

### Trigger

Automatically updates the species inventory when modifying an area.

### Event

Generates weekly reports on accommodation occupancy.

***

## User Roles and Permissions

| Role            | Permissions                              |
| --------------- | ---------------------------------------- |
| Administrator   | Full access (CREATE, DROP, GRANT, etc.). |
| Park Manager    | Management of parks, areas, and species. |
| Researcher      | Read access to projects and species.     |
| Auditor         | Access to financial reports.             |
| Visitor Manager | CRUD for visitors and accommodations.    |

**Instructions to assign roles**:

```sql
CREATE USER 'auditor'@'localhost' IDENTIFIED BY 'password';  
GRANT SELECT ON natural_parks.project TO 'auditor'@'localhost';  
```

***

## Repository Structure Summary

```bash
natural_parks/  
├── DDL/  
│   └── ddl.sql                 # Table and relationship creation  
├── DML/  
│   └── dml.sql                 # Initial data (50+ records per table)  
├── Queries/  
│   └── dql_select.sql          # 100 SQL queries  
├── Procedures/  
│   └── dql_procedures.sql  # 20 stored procedures  
├── Functions/  
│   └── dql_functions.sql       # 20 SQL functions  
├── Triggers/  
│   └── dql_triggers.sql        # 20 triggers  
├── Events/  
│   └── dql_events.sql         # 20 scheduled events  
├── Documentation/  
│   └── Diagram.jpg            # ER diagram of the database  
└── README.md                   # Main documentation  
```

***

## License and Contact

**License**: MIT.\
**Contact**: [juancrfig@gmail.com](mailto\:juancrfig@gmail.com) | [Submit an issue on GitHub](https://github.com/juancrfig/natural_parks/issues).
