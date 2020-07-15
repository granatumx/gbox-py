# Function that leverages MailJet to send a bug report email to the user and developer

def bug_report(from_gbox, error_message=""):

    # Takes the stack traceback as an argument to email
    with open(Path("/var/granatum/shared.pkl"), "rb") as fp:
        shared = pickle.load(fp)
        email_address = shared["email_address"]

    api_key = "de76ff500a135ca0fe86f09d7107bda6"
    api_secret = "a8cb3bfd13e09b8c8b13c2516cc5a542"
    mailjet = Client(auth=(api_key, api_secret), version='v3.1')
    data = {
      'Messages': [
        {
          "From": {
            "Email": "lana.garmire.group@gmail.com",
            "Name": "GranatumX pipeline"
          },
          "To": [
            {
              "Email": "amantrav@umich.edu",
              "Name": "Developer"
            },
            {
              "Email": email_address,
              "Name": "User"
            }
          ],
          "Subject": "Bug report in " + from_gbox,
          "TextPart": "There was an error encountered in the " + from_gbox + " step of the GranatumX pipeline: \n\n" + error_message
        }
      ]
    }
    result = mailjet.send.create(data=data)