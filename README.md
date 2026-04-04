# Finance Data Processing and Access Control System

## Project Objective
A full-stack application featuring a secure Spring Boot backend and a modern React.js frontend. The system manages user roles, permissions, financial entries, and provides summary-level analytics through a role-based access dashboard. 

The backend will be designed focusing on correctness, clarity, clean implementation, and adherence to standard enterprise design patterns.

## Tech Stack
*   **Backend**: Java 17+, Spring Boot 3.x, Spring MVC, Spring Data JPA, Spring Security (JWT for stateless authentication)
*   **Database**: MySQL
*   **Frontend**: React.js (Vite), modern CSS for stunning UI, Axios for API calls
*   **Architecture**: Layered MVC Architecture (Controller -> Service -> Repository)

---

## 🏛 Architecture Overview (Spring MVC Layered Design)

We will follow a clean, maintainable structure:
1.  **Controller Layer (`@RestController`)**: Handles incoming HTTP requests, validates input using Spring Boot Validation (`@Valid`), and returns structured JSON responses (`ResponseEntity`).
2.  **Service Layer (`@Service`)**: Contains core application business logic, authorization checks that are specific to business rules, and transaction management (`@Transactional`).
3.  **Repository Layer (`@Repository`)**: Extends Spring Data `JpaRepository` for seamless data persistence, retrieval, and optimized aggregation queries.
4.  **Security Layer**: Global method security (`@PreAuthorize`), JWT token generation and validation filters, and Role-Based Access Control (RBAC).
5.  **DTOs & Mappers**: Data Transfer Objects (DTOs) isolate the database entities from the API layer, preventing accidental data leakage.
6.  **Global Exception Handling**: Centralized `@ControllerAdvice` to format error messages gracefully.

---

## 🔐 Roles and Permissions

*   **VIEWER**: Can only view dashboard summary data. Cannot view individual records or modify anything.
*   **ANALYST**: Can view the dashboard summaries AND view specific financial records.
*   **ADMIN**: Full access. Can create, read, update, and delete financial records. Can also manage (view, edit) users and their roles/statuses.

---

## 🛠 Required APIs (The Backend Contract)

### 1. Authentication APIs
*   `POST /api/auth/register` - Register a new user (defaults to VIEWER role or as configured).
*   `POST /api/auth/login` - Authenticate, validate credentials, and return a JWT token.

### 2. User Management APIs (Role: ADMIN)
*   `GET /api/users` - List all users in the system.
*   `GET /api/users/{id}` - Get a specific user's details.
*   `PUT /api/users/{id}/role` - Update a user's role (e.g., promote to ANALYST).
*   `PUT /api/users/{id}/status` - Toggle a user's status (Active / Inactive).

### 3. Financial Records APIs
*   `POST /api/records` - Create a new financial record. **(ADMIN only)**
*   `GET /api/records` - View all records. Supports filtering by query parameters (e.g., `?type=INCOME&category=SALES`). **(ADMIN, ANALYST)**
*   `GET /api/records/{id}` - View a specific record by its ID. **(ADMIN, ANALYST)**
*   `PUT /api/records/{id}` - Update a specific record. **(ADMIN only)**
*   `DELETE /api/records/{id}` - Soft/Hard delete a record. **(ADMIN only)**

### 4. Dashboard Summary APIs (Role: VIEWER, ANALYST, ADMIN)
*   `GET /api/dashboard/summary` - Returns high-level metrics: Total income, Total expenses, and Net balance.
*   `GET /api/dashboard/category-totals` - Returns aggregated financial totals grouped by category (ideal for pie charts).
*   `GET /api/dashboard/recent-activity` - Returns the top 5-10 most recently added financial records.

---

## 🚀 Step-by-Step Implementation Guide

### Phase 1: Project Setup & Configuration (Backend)
1. Initialize the Spring Boot project via Spring Initializr, including dependencies: **Spring Web, Spring Data JPA, MySQL Driver, Spring Security, Validation, and Lombok**.
2. Configure `application.yml` for the database connection and JWT secret keys.
3. Establish the base directory structure: `config`, `controller`, `service`, `repository`, `entity`, `dto`, `exception`, `security`.

### Phase 2: Domain Modeling & Database
1. Create the `User` entity (id, name, email, password, role, active status).
2. Create the `Role` Enum (`VIEWER`, `ANALYST`, `ADMIN`).
3. Create the `FinancialRecord` entity (id, amount, type, category, date, description, createdAt).
4. Create the corresponding Spring Data JPA Interfaces (`UserRepository`, `FinancialRecordRepository`).

### Phase 3: Core Security (JWT & RBAC)
1. Implement `UserDetails` and a custom `UserDetailsService` to load users from the DB.
2. Build JWT utility classes to handle generating tokens, validating tokens, and extracting claims.
3. Set up the `JwtAuthenticationFilter` to intercept requests, validate the token header, and set the Spring Security Context.
4. Configure the `SecurityFilterChain` to secure endpoints and define CORS rules.

### Phase 4: Business Logic Definition (Services)
1. **AuthService**: Logic for registering users, hashing passwords (`BCrypt`), and handling logins.
2. **UserService**: Logic for retrieving users and updating their properties.
3. **FinancialRecordService**: Logic for CRUD operations. Implement logic to handle data parsing and validations cleanly.
4. **DashboardService**: Implement database aggregation queries (using JPQL) to efficiently summarize data without pulling all rows into memory.

### Phase 5: API Exposure & Error Handling (Controllers)
1. Create REST Controllers exposing the endpoints described above.
2. Secure the controller methods using `@PreAuthorize("hasRole('ADMIN')")` based on the defined rules.
3. Map internal Entities to outbound DTOs before responding.
4. Build a Global Exception Handler (`@ControllerAdvice`) to catch things like `EntityNotFoundException` (404), validation failures (400), and access denied errors (403), converting them to neat JSON error structures.

### Phase 6: Frontend Development (React)
1. Setup React using `Vite`.
2. Setup styling using modern CSS or a carefully selected layout framework.
3. Setup an Axios interceptor to securely attach the user's JWT to all outgoing backend requests.
4. Develop the React routing:
   * **Public:** Login/Register pages.
   * **Protected:** Dashboard View (available to all logged-in users).
   * **Protected:** Records View (Analysts & Admins only).
   * **Protected:** User Management View (Admins only).
5. Fetch the Dashboard APIs and use charting libraries (e.g., Recharts or Chart.js) to build a beautiful presentation of the data.

### Phase 7: Optimization & Polish
1. Add Swagger/OpenAPI documentation (springdoc-openapi) to visualize backend endpoints.
2. Add comprehensive input validation constraints on DTOs.
3. Final review of code format, separation of concerns, and logical flows.

---
**Ready to begin? Let's start with Phase 1 by generating the Spring Boot project footprint!**
