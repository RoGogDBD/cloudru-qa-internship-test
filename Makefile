.PHONY: help install test test-selenium lint format clean report

VENV_NAME?=venv
PYTHON=${VENV_NAME}/bin/python
PIP=${VENV_NAME}/bin/pip
TASK1_DIR=task_1
TASK2_DIR=task_2

help:
	@echo "Доступные команды:"
	@echo "  make install         - Установить зависимости и настройки"
	@echo "  make run-sort        - Запустить перовое задание"
	@echo "  make test-selenium   - Запустить Selenium тесты"
	@echo "  make lint            - Проверить стиль кода"
	@echo "  make format          - Автоформатирование кода"
	@echo "  make report          - Открыть HTML-отчёт после тестов"
	@echo "  make clean           - Очистить проект"
	@echo "  make help            - Показать это сообщение"

install:
	@echo "Создание виртуального окружения..."
	python3 -m venv $(VENV_NAME)
	@echo "Установка зависимостей..."
	${PIP} install --upgrade pip
	${PIP} install selenium webdriver-manager pytest pytest-html
	@echo "========================================================================================="
	@echo "✅ Установка завершена. Активируйте окружение командой: source ${VENV_NAME}/bin/activate"
	@echo ""
	@echo "Важно! Для корректной работы тестов необходимо установить браузер:"
	@echo " - Google Chrome или Chromium (https://www.google.com/chrome/)"
	@echo ""
	@echo "Для Linux может потребоваться установка WSL и браузеров через менеджер пакетов."
	@echo "Команда для установки Google Chrome: install-chrome"

install-chrome:
	@echo "Установка Google Chrome..."
	@if [ "$$(uname)" = "Linux" ]; then \
		echo "Определена Linux-система. Установка Chrome через wget..."; \
		wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O chrome.deb && \
		sudo apt update && \
		sudo apt install -y ./chrome.deb && \
		rm chrome.deb && \
		echo "✅ Google Chrome установлен."; \
	elif [ "$$(uname)" = "Darwin" ]; then \
		echo "macOS обнаружен. Пожалуйста, скачайте и установите Chrome вручную: https://www.google.com/chrome/"; \
	else \
		echo "Платформа не поддерживается. Установите Google Chrome вручную: https://www.google.com/chrome/"; \
	fi

run-sort:
	@echo "Запуск task_1/sort.py..."
	${PYTHON} ${TASK1_DIR}/sort.py

test-selenium:
	@echo "Запуск Selenium теста через pytest..."
	cd ${TASK2_DIR} && ../${PYTHON} -m pytest --html=report.html --self-contained-html

report:
	@echo "Открытие HTML-отчёта..."
	xdg-open ${TASK2_DIR}/report.html || open ${TEST_DIR}/report.html || echo "Открой файл вручную: ${TEST_DIR}/report.html"

lint:
	@echo "Проверка стиля кода..."
	${PIP} install flake8 black
	${VENV_NAME}/bin/flake8 --max-line-length=120 task_1 task_2
	${VENV_NAME}/bin/black --check task_1 task_2

format:
	@echo "Автоформатирование кода..."
	${VENV_NAME}/bin/black task_1 task_2
	@echo "========================================================================================="
	@echo "✅ Готово!"

clean:
	@echo "Очистка проекта..."
	rm -rf ${TASK2_DIR}/__pycache__ ${TASK2_DIR}/.pytest_cache
	rm -f ${TASK2_DIR}/*.log ${TASK2_DIR}/*.png ${TASK2_DIR}/*.html
	rm -rf ${VENV_NAME}
	find . -name '*.pyc' -delete
	find . -name '__pycache__' -delete
	@if [ -f chrome.deb ]; then rm chrome.deb && echo "🗑️  Удалён временный файл chrome.deb"; fi
	@echo "========================================================================================="
	@echo "✅ Очистка завершена"
	@echo "⚠️  Если виртуальное окружение активно, деактивируй: deactivate"