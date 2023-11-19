# dart password manager (dpassman)
This project is a simple CLI password manager made in pure dart with few dart packages.
# Disclaimer:
**This project is intended solely for educational purposes to understand how password managers work. It is not intended to be used as a secure solution to save or manage your passwords. It is strongly recommended that you use trusted password managers that are endorsed and recommended by the security community for securely storing your passwords.**

Please be aware that the implementation in this project may not follow industry best practices or provide the necessary level of security required for real-world use. It is essential to prioritize the security of your sensitive information and rely on established, reputable password managers that have undergone rigorous security audits and are regularly updated to address emerging threats.

By using this project, you acknowledge and accept that it is for educational purposes only, and you should not rely on it as a secure password management solution.

--------
## purpose 
This project is heavily inspired by [pass](https://www.passwordstore.org) A unix password manager.
I wanted to make a project that help me improve my skills in programming and understanding in some principles and I really liked the idea of a pass so made of for learning and fun.

## How It Works
The Dart Password Manager (dpassman) is a command-line interface (CLI) tool designed for educational purposes. It showcases the basic concepts of password management and encryption in a simplified manner. Please note that this tool is not intended for secure, real-world use.

dpassman allows you to store passwords in an encrypted file located in a hidden directory within your home directory. The passwords are protected by a master password, which you provide when accessing or adding passwords.

When adding a password to dpassman, you provide the master password and enter the details of the password, such as the password itself and additional information associated with it. The tool then saves this information in a JSON file and encrypts it for storage.

To retrieve passwords from dpassman, you need to provide the master password and specify the name of the password you want to access. The tool decrypts the password file, retrieves the requested password, and displays it on the CLI.

Their are also some other functionality see `dpassman help`.
