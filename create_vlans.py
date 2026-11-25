from getpass import getpass
from netmiko import ConnectHandler


def connect_device(host, username):
    return {
        "device_type": "cisco_ios",
        "host": host,        
        "username": username,           
        "password": getpass("SSH Password: "),
    }


def configure_vlans(device, commands):
    with ConnectHandler(**device) as net_connect:
        output = net_connect.send_config_set(commands)
        print(output)

        save_output = net_connect.save_config()
        print(save_output)

def main():

    host = input("IP Address: ")
    username = input("Username: ")

    switch = connect_device(host, username)
    
    vlans = {
        10: "Data",
        20: "Management",
        30: "VoIP",
        40: "Guest"
    }

    commands = []

    for vlan_id, vlan_name in vlans.items():
        commands.append(f"vlan {vlan_id}")
        commands.append(f"name {vlan_name}")
    
    configure_vlans(switch, commands)

if __name__ == "__main__":
    main()
