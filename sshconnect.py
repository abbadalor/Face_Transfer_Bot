import paramiko
from scp import SCPClient

title = input("Choose title for the video > ")

ssh = paramiko.SSHClient()
ssh.load_system_host_keys()
ssh.connect("192.168.1.152", username="adam", password="123")
scp = SCPClient(ssh.get_transport())
scp.put('videos', recursive=True, remote_path='C:/DeepFaceLab/DeepFaceLab_NVIDIA/')
scp.close()
ssh_stdin, ssh_stdout, ssh_stderr = ssh.exec_command("cd C:/DeepFaceLab/DeepFaceLab_NVIDIA/ & echo " + title + " > title.txt")
#ssh_stdin, ssh_stdout, ssh_stderr = ssh.exec_command("py DeepFakebot.py")
ssh_stdin, ssh_stdout, ssh_stderr = ssh.exec_command("cd C:/DeepFaceLab/DeepFaceLab_NVIDIA/ & py DeepFakebot.py")
print(ssh_stderr.readlines())
print(ssh_stdout.readlines())

