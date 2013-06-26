from app import app

if '__main__' == __name__:
    app.run(debug=False, host='0.0.0.0', port=5000)
