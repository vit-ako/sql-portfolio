# SQL Portfolio — Retail Sales Analysis

## О проекте
Этот проект показывает мои навыки работы с SQL на реальных данных розничных продаж.
Я использую датасет Omni-Channel Sales Dataset (10 000+ транзакций) и демонстрирую полный спектр возможностей SQL: от базовой фильтрации до оптимизации запросов с индексами.

Все запросы выполнены в PostgreSQL и готовы к просмотру, воспроизведению и обсуждению на техническом интервью.

## Что я умею (подтверждено кодом)

| Категория | Навыки |
|-----------|--------|
| Basic queries | WHERE, ORDER BY, LIMIT, GROUP BY, HAVING, CASE WHEN |
| Window functions | ROW_NUMBER, RANK, LAG, LEAD, FIRST_VALUE, SUM OVER, AVG OVER, NTILE |
| Aggregations | ROLLUP, CUBE, GROUPING SETS, FILTER, DATE_TRUNC |
| CTE & Subqueries | подзапросы в WHERE/SELECT/EXISTS, многоуровневые WITH, рекурсивная CTE, Pareto-анализ |
| Optimization | EXPLAIN ANALYZE, создание индексов (простых и составных), анализ размера таблицы |

## Технологии

| Технология | Назначение |
|------------|------------|
| PostgreSQL 18 | База данных |
| Omni-Channel Sales Dataset (Kaggle) | Данные для анализа |
| VS Code (Database Client) | SQL клиент |
| Git + GitHub | Версионирование |
| GitHub Actions | CI/CD проверки |

## CI/CD — Автоматическая проверка SQL

Этот проект настроен на **автоматическое тестирование всех SQL запросов** при каждом изменении.

### Как это работает

1. При создании Pull Request из `develop` в `main` автоматически запускается GitHub Actions
2. Поднимается временный контейнер с PostgreSQL
3. Последовательно выполняются все SQL файлы из папки `src/sql/`
4. Если хотя бы один запрос содержит ошибку — CI покажет красный ❌ и заблокирует слияние
5. Если все запросы валидны — CI становится зелёным ✅ и код можно мержить

### Что проверяется

- ✅ Корректность синтаксиса SQL
- ✅ Работоспособность оконных функций
- ✅ Отсутствие синтаксических ошибок в CTE

### Статус сборки

![CI Status](https://github.com/vit-ako/sql-portfolio/actions/workflows/sql-ci.yml/badge.svg?branch=main)

> Значок автоматически показывает текущий статус CI (зелёный — всё работает)

### Структура SQL файлов
- src/sql/
- ├── 01_create_tables.sql # Создание таблицы retail_sales
- ├── 02_basic_queries.sql # Базовые запросы (WHERE, GROUP BY, HAVING)
- ├── 03_window_functions.sql # Оконные функции (RANK, LAG, LEAD)
- ├── 04_aggregations.sql # Сложные агрегации (ROLLUP, CUBE)
- ├── 05_cte_subqueries.sql # WITH и подзапросы
- └── 06_optimization.sql # EXPLAIN ANALYZE, индексы
