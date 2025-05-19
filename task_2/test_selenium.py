import os
import pytest
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

URL = "https://example.com/"
EXPECTED_TITLE = "Example"
REDIRECT_URL = "https://www.iana.org/help/example-domains"


@pytest.fixture(scope="function")
def browser():
    options = Options()
    options.add_argument("--headless")
    options.add_argument("--no-sandbox")
    options.add_argument("--disable-dev-shm-usage")

    chrome_path = os.getenv("CHROME_BIN")
    if chrome_path:
        options.binary_location = chrome_path

    driver = webdriver.Chrome(options=options)
    yield driver
    driver.quit()


def test_open_page(browser):
    browser.get(URL)
    assert browser.current_url == URL


def test_title_contains_keyword(browser):
    browser.get(URL)
    assert EXPECTED_TITLE in browser.title


def test_more_info_link_redirects(browser):
    browser.get(URL)
    link = WebDriverWait(browser, 10).until(
        EC.element_to_be_clickable((By.CSS_SELECTOR, 'a[href^="https://www.iana.org"]'))
    )
    assert "More information" in link.text
    link.click()
    WebDriverWait(browser, 10).until(EC.url_contains("iana.org"))
    assert "iana.org" in browser.current_url


def test_final_redirect_url(browser):
    browser.get(URL)
    link = WebDriverWait(browser, 10).until(
        EC.element_to_be_clickable((By.CSS_SELECTOR, 'a[href^="https://www.iana.org"]'))
    )
    link.click()
    WebDriverWait(browser, 10).until(EC.url_to_be(REDIRECT_URL))
    assert browser.current_url == REDIRECT_URL
