"""Display and Export all users
"""
from flask import Flask, render_template, send_file
import requests
import pandas as pd


raw_user_data_api = 'https://reqres.in/api/users'
headings = ('ID', 'Email', 'First Name', 'Last Name', 'Avatar')


def get_all_users():
    """Get all users from Raw User Data API"""
    results = requests.get(raw_user_data_api).json()
    users = results["data"]
    for page in range(2, results["total_pages"] + 1):
        results = requests.get(raw_user_data_api + f"?page={page}").json()
        users.extend(results["data"])
    return users


def create_app():
    """Create Flask app serving two paths"""

    app = Flask(__name__)

    @app.route('/', methods=['GET'])
    def index():
        return render_template('users.html', headings=headings, data=get_all_users())

    @app.route('/download', methods=['GET'])
    def download_file():
        data_frame = pd.DataFrame(get_all_users())
        writer = pd.ExcelWriter('All_Users.xlsx', engine='xlsxwriter')
        data_frame.to_excel(writer)
        writer.save()

        return send_file('../All_Users.xlsx', as_attachment=True)
    return app