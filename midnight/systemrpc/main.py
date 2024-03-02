import psutil
from pypresence import Presence
import time
import platform
import GPUtil
import os
from dotenv import load_dotenv
import logging
import subprocess

# Load environment variables from .env file
load_dotenv()

# Setup logging
logging.basicConfig(filename='systemrpc.log', level=logging.INFO, format='%(asctime)s [%(levelname)s]: %(message)s')

# Store the script start time and system uptime
script_start_time = int(time.time())
system_start_time = int(time.time() - psutil.boot_time())

def get_hyprland_version():
    try:
        version_info = subprocess.check_output(["hyprctl", "version"], text=True)
        tag_line = [line for line in version_info.strip().split('\n') if "Tag:" in line][0]  # Filter the line containing "Tag:"
        _, tag = tag_line.split(':', 1)
        version = tag.strip()
        return version
    except Exception as e:
        logging.error(f"Error retrieving Hyprland version: {e}")
        return "N/A"

def get_system_info():
    try:
        network_info = psutil.net_io_counters()

        system_info = {
            "platform": platform.system(),
            "cpu_usage": round(psutil.cpu_percent(interval=1), 2),
            "ram_usage": round(psutil.virtual_memory().used / (1024 ** 3), 2),  # Convert to gigabytes with 2 decimal places
            "gpu_usage": get_gpu_usage(),
            "os": f"{platform.system()} {platform.machine()}",
            "desktop_environment": "Hyprland",  # Replace with your desktop environment
            "hyprland_version": get_hyprland_version(),
            "network_upload": round(network_info.bytes_sent / (1024 ** 3), 2),  # Convert to gigabytes with 2 decimal places
            "network_download": round(network_info.bytes_recv / (1024 ** 3), 2),
            "elapsed_time": get_elapsed_time(),
        }
        return system_info
    except Exception as e:
        logging.error(f"Error getting system info: {e}")
        raise

def get_gpu_usage():
    try:
        gpus = GPUtil.getGPUs()
        gpu_usage = [gpu.load * 100 for gpu in gpus]
        return gpu_usage
    except Exception as e:
        logging.error(f"Error retrieving GPU information: {e}")
        return "N/A"
def get_cpu_thread_usage():
    try:
        # Get CPU usage for each thread
        thread_usage = psutil.cpu_percent(percpu=True, interval=1)
        return [f"{usage}%" for usage in thread_usage]
    except Exception as e:
        logging.error(f"Error retrieving CPU thread information: {e}")
        return []

def get_elapsed_time():
    elapsed_seconds = time.time() - script_start_time
    elapsed_minutes, elapsed_seconds = divmod(elapsed_seconds, 60)
    elapsed_hours, elapsed_minutes = divmod(elapsed_minutes, 60)
    elapsed_days, elapsed_hours = divmod(elapsed_hours, 24)
    
    uptime_seconds = time.time() - system_start_time
    uptime_minutes, uptime_seconds = divmod(uptime_seconds, 60)
    uptime_hours, uptime_minutes = divmod(uptime_minutes, 60)
    uptime_days, uptime_hours = divmod(uptime_hours, 24)

    return f"Script: {int(elapsed_days)}d {int(elapsed_hours)}h {int(elapsed_minutes)}m | Uptime: {int(uptime_days)}d {int(uptime_hours)}h {int(uptime_minutes)}m"

def update_discord_rich_presence(client, system_info):
    try:
        gpu_usage_str = ", ".join([f"{round(usage, 2)}%" for usage in system_info['gpu_usage']])

        presence_data = {
            "details": f"📟 {system_info['cpu_usage']}% | 💾 {system_info['ram_usage']} GB | 🖥️ {gpu_usage_str}",
            "state": f"⬆️  {system_info['network_upload']} GB | ⬇️ {system_info['network_download']} GB",
            "large_image": "hyprland",  # Replace with your large image key
            "large_text": f"{system_info['hyprland_version']}",
            "small_image": "archlinux",  # Replace with your small image key
            "small_text": f"Arch {system_info['os']} ({platform.release()})",
            "start": script_start_time  # Use start to show elapsed time
        }
        client.update(**presence_data)
    except Exception as e:
        logging.error(f"Error updating Discord Rich Presence: {e}")
        raise

def main():
    try:
        client_id = os.getenv("DISCORD_CLIENT_ID", "your_default_client_id")
        rpc = Presence(client_id)
        rpc.connect()

        print("Connected to Discord")

        while True:
            try:
                system_info = get_system_info()
                print("System info retrieved")

                try:
                    update_discord_rich_presence(rpc, system_info)
                    print("Discord Rich Presence updated")
                except Exception as update_error:
                    print(f"Error updating Discord Rich Presence: {update_error}")

                time.sleep(15)  # Update every 15 seconds, adjust as needed
            except Exception as system_info_error:
                print(f"Error getting system info: {system_info_error}")

    except KeyboardInterrupt:
        pass

    except Exception as main_error:
        print(f"An unexpected error occurred: {main_error}")

    finally:
        try:
            rpc.close()
            print("Disconnected from Discord")
        except Exception as close_error:
            print(f"Error closing Discord Rich Presence connection: {close_error}")

if __name__ == "__main__":
    main()

