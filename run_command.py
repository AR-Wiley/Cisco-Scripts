from getpass import getpass
from netmiko import ConnectHandler

def connect_device(host, username):
    return {
        "device_type": "cisco_ios",
        "host": host,        
        "username": username,           
        "password": getpass("SSH Password: "),
    }

def run_command(device, command):
    with ConnectHandler(**device) as net_connect:
        output = net_connect.send_command(command)
        print(output)

def main():

    host = input("IP Address: ")
    username = input("Username: ")
    command = input("Command: ")

    switch = connect_device(host, username)
    int_brief(switch, command)


if __name__ == "__main__":
    main()
