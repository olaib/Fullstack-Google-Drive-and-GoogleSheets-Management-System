// ignore_for_file: constant_identifier_names, non_constant_identifier_names
// ============================ APP ============================
const String SERVER_URL = 'http://localhost:8000',
    APP_NAME = 'Google Sheets and Google Drive Manager',
// ============================ TITLES ============================

    MENU_TOOLTIP_NAME = 'Menu',
    SIGNOUT_TITLE = 'Sign Out',
    ABOUT_TITLE = 'About',

// =========================== KEYS ===========================
    ROOT_NAV_KEY = 'root',
    THEME_STATE_KEY = 'THEME_STATE',
    SPREADSHEET_ID_KEY = 'SPREADSHEET_ID', // in preference utils

    // =========================== PARAMS ===========================
    SHEET_ID_PARAM = 'sheetId',
    SHEET_TITLE_PARAM = 'title',

    // =========================== OPERATORS ===========================
    ADD = '+',
    SUBTRACT = '-',
    MULTIPLY = '*',
    DIVIDE = '/',
    EXPONENT = '^';
    
final RegExp EXPRESSION_REGEX = RegExp(
        r'^((?:[A-Z]+\d+|\d+)\s*([+\-*\/^]\s*(?:[A-Z]+\d+|\d+))?(?:\s*[+\-*\/^]\s*(?:[A-Z]+\d+|\d+))*)$'),
    CELL_REGEX = RegExp(r'[A-Z]+\d+');
const OPERATORS = <String>['+', '-', '*', '/', '^'];

// ============================ TEXTS ============================
const String PAGE_NOT_FOUND_TITLE = '404 🤷‍♂️',
    DELETE_ROW_CONFIRM_MESSAGE = 'Are you sure you want to delete this row?',
    CANCEL = 'Cancel',
    ACTIONS = 'Actions',
    CONFIRM = 'Confirm',
    HOME = 'Home',
    BACK = 'Back',
    ABOUT = 'About',
    MANAGE_SHEETS = 'Manage Sheets',
    EMPTY_STRING = '______',
    DATE_FORMAT = 'dd/MM/yyyy HH:mm:ss',
    SLASH = '/',
    ZERO_DURATION_STRING_FORMATE = '00:00:00',
    UNDERSCORE = '_',
    EMPTY_DATE_FORMATE = EMPTY_STRING,
    YES = 'Yes',
    NO = 'No',
    UPDATED_SUCCESSFULLY = 'Updated successfully',
    MESSAGE_404 =
        "It seems I've lost my way! Time for a coffee break to wake up and find my way back. And if you're missing home, you can press the 'Home' button to return to the starting point. ☕️🏠😅",
    GENERIC_ERROR_TITLE = 'Error: An unexpected issue occurred 😞',
    EXAMPLE_SPREADSHEET_ID =
        "Example: https://docs.google.com/spreadsheets/d/<spreadsheet_id>/edit",
    HEADERS_RANGE = 'A1:1';
const Map<String, String> JSON_HEADERS = {'Content-Type': 'application/json'};
