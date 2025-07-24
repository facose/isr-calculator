**This README is written in English to ensure wider accessibility.**

> ## TL;DR
> 
> This Ruby CLI app calculates weekly ISR (income tax) for Mexican employees using official tax tables and supports three adjustment strategies: no adjustment, basic adjustment, and projected adjustment. The code is organized with clear separation of concerns: domain entities (Employee, Week), calculation strategies, and ISR tax tables as services. It follows clean OOP principles and the Single Responsibility Principle for maintainability and scalability.
> 
> Run the app with:
> ```bash
> rake run_app
> ```
> Run tests with:
> ```bash
> rake test
> ```
> Zip the project with:
> ```bash
> rake zip_project
> ```
> Possible improvements include better CLI validation, more payment periodicities, enhanced error handling, and expanded tests.

# ISR Weekly Calculator (Extended Version)

## Overview
This CLI application calculates the weekly ISR (Income Tax) for employees in Mexico, supporting three adjustment modes:

- No adjustment
- Basic adjustment
- Projected adjustment

It uses official ISR tables for both weekly and monthly frequencies to ensure tax calculations are accurate regardless of pay periodicity.

## Features

- Supports weekly salary inputs with configurable adjustment strategy
- Applies proper ISR tax brackets for weekly and monthly calculations
- Modular, object-oriented design for easy extension and maintenance
- Minimal dependencies, tested with Minitest

## Run the CLI

```bash
rake run_app
```
Alternatively, you can run the main script directly:

```bash
ruby bin/isr_calculator.rb
```

OR:

```bash
chmod +x bin/isr_calculator.rb
./bin/isr_calculator.rb
```

## Usage

Define an employee with their name, adjustment type (`:no_adjustment`, `:basic_adjustment`, or `:projected_adjustment`), and weekly salary data

Use the CLI prompts or call the core classes directly to calculate ISR per week

Results display ISR amounts per week with proper adjustment applied

## Project Structure

```plaintext
.
├── bin/                                    # CLI entry point scripts
│   ├── isr_calculator.rb                   # Main CLI script
│   └── zip_project.rb                      # Script to zip the project
├── lib/                                    # Core application logic
│   ├── entities/                           # Domain entities (Employee, Week)
│   │   ├── employee.rb                     # Employee class with ISR calculation logic
│   │   └── week.rb                         # Week class with salary and days worked
│   ├── helpers/                            # Helper modules for CLI interaction
│   │   └── cli_helpers.rb                  # CLI input/output helpers
│   ├── strategies/                         # ISR adjustment strategies
│   │   ├── basic_adjustment.rb             # Basic adjustment strategy
│   │   ├── no_adjustment.rb                # No adjustment strategy
│   │   └── projected_adjustment.rb         # Projected adjustment strategy
│   ├── services/                           # ISR tables and calculation logic
│   │   └── isr_table.rb                    # ISR table with tax brackets
├── test/                                   # Minitest unit tests
│   ├── entities/                           # Tests for domain entities
│   │   ├── employee_test.rb                # Tests for Employee class
│   │   └── week_test.rb                    # Tests for Week class
│   ├── strategies/                         # Tests for ISR adjustment strategies
│   │   ├── basic_adjustment_test.rb        # Tests for BasicAdjustment strategy
│   │   ├── no_adjustment_test.rb           # Tests for NoAdjustment strategy
│   │   └── projected_adjustment_test.rb    # Tests for ProjectedAdjustment strategy
│   ├── services/                           # Tests for ISR tables and calculation logic
│   │   └── isr_table_test.rb               # Tests for ISRTable class
│   └── test_helper.rb                      # Minitest setup
├── README.md                               # Project documentation
├── Rakefile                                # Rake tasks for executing, testing and packaging
```

## Main Classes

- **Employee**: Represents an employee, stores weeks worked and adjustment strategy
- **Week**: Represents salary and days worked per week
- **ISRTable**: Holds tax brackets and calculates ISR based on income and frequency

## Adjustment Strategies:

- **NoAdjustment**: Simple weekly ISR without correction
- **BasicAdjustment**: Weekly ISR with correction in last week of the month
- **ProjectedAdjustment**: Projects monthly income for proportional weekly ISR and last-week adjustment

## Diagrams

To better understand the logic and structure behind the ISR calculation, here are two helpful diagrams:

- [Weekly ISR Calculation Flowchart](https://lucid.app/lucidchart/3a581470-4924-4a89-b51f-94b2e7eabf8b/edit?viewport_loc=-942%2C-263%2C4452%2C2189%2C0_0&invitationId=inv_0938297d-5980-43df-8f90-fb8de24e4d5d)
- [UML Class Diagram](https://lucid.app/lucidchart/9032b0b3-77a9-4d98-9be9-84decfda718a/edit?viewport_loc=-453%2C-265%2C3487%2C1714%2CHWEp-vi-RSFO&invitationId=inv_18f8dab0-8c76-4a7e-9630-124648688089)

## Design Decisions & Assumptions

- Used Ruby Structs to model ISR tax brackets for simplicity and clear data representation.
- Each Employee instance uses a single, fixed adjustment strategy type throughout the entire calculation period.
- Gross salary is used as the taxable base (no additional deductions).
- Week entities contain both salary and days worked, allowing accurate projections and flexible week definitions.
- Assumed weeks are 7 days long by default, with the option to override when input data specifies otherwise.
- Calculations with last week adjustments ensure ISR is never negative by using `max(0.0, calculated_isr)`. Not sure if this is the best approach as it could be part of a different reimbursement process.
- The CLI focuses on minimalism, providing straightforward input/output handling and delegating all business logic to domain classes and strategies.
- Enforced a strategy base class to guarantee consistent interfaces (calculate_isr), easing scalability and maintenance.
- Code organization follows the Single Responsibility Principle (SRP):
  - Entities encapsulate domain data and behavior (Employee, Week).
  - Strategies handle specific ISR calculation algorithms.
  - Services provide auxiliary utilities like ISR tax tables.
- Designed with extensibility in mind, allowing new adjustment strategies or tax rules to be added without modifying existing classes.

## Running Tests

To run the unit tests using Minitest:

```bash
rake test
```

## Why Use Rakefile and Minitest?

We use Rake as a simple and standard task runner to execute common tasks such as running the CLI app, tests, and packaging the project. Since Rake comes bundled with Ruby by default, it requires no extra dependencies and provides:

- **Consistency**: One command (`rake task_name`) to manage tasks.

- **Convenience**: Easy for contributors and automation.

- **Extendability**: Add or modify tasks easily as the project grows.

Similarly, Minitest is chosen for testing because it is the default testing framework included with Ruby. This ensures:

- **Zero external dependencies**.

- **Fast, lightweight testing**.

- **Straightforward integration with Rake for running tests**.

Using these built-in Ruby tools promotes simplicity, reduces setup friction, and keeps the project accessible to anyone with a Ruby environment.

## Zipping the Project

To create a zip archive of the project, run:

```bash
rake zip_project
```

Alternatively, you can run the zipping script directly:

```bash
ruby bin/zip_project.rb
```
OR:

```bash
chmod +x bin/zip_project.rb
./bin/zip_project.rb
```

## Possible Improvements

- Add more robust CLI input validation
- Support other payment periodicities (biweekly)
- Add extra error handling and logging    
- Improve test coverage for edge cases