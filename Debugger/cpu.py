import serial
import time


SERIAL_PORT = "COM8"
BAUD_RATE = 115200


class CPU:

    def __init__(self):
        self.ser = serial.Serial(
            SERIAL_PORT,
            BAUD_RATE,
            timeout=1
        )

        time.sleep(0.1)

        print("Connected to Tang Nano on COM8")

    def send_command(self, command, response_length):

        self.ser.reset_input_buffer()

        self.ser.write(bytes([command]))

        response = self.ser.read(response_length)

        return response

    def run(self):

        response = self.send_command(0x01, 1)

        print(f"Received: {response!r}")

        if response == bytes([0x81]):
            return True

        return False

    def pause(self):

        response = self.send_command(0x02, 1)

        print(f"Received: {response!r}")

        if response == bytes([0x82]):
            return True

        return False

    def clock(self):

        response = self.send_command(0x03, 1)

        print(f"Received: {response!r}")

        if response == bytes([0x83]):
            return True

        return False

    def step(self):

        response = self.send_command(0x04, 1)

        print(f"Received: {response!r}")

        if response == bytes([0x84]):
            return True

        return False

    def read_pc(self):

        response = self.send_command(0x10, 2)

        print(f"Received: {response!r}")

        if len(response) != 2:
            return None

        if response[0] != 0x90:
            return None

        pc = response[1] & 0x3F

        return pc

    def read_register(self, reg):

        if reg < 0 or reg > 7:
            return None

        response = self.send_command(0x20 + reg, 2)

        print(f"Received: {response!r}")

        if len(response) != 2:
            return None

        if response[0] != 0xA0 + reg:
            return None

        return response[1]

    def read_instruction(self):

        response = self.send_command(0x11, 3)

        print(f"Received: {response!r}")

        if len(response) != 3:
            return None

        if response[0] != 0x91:
            return None

        instruction = (response[2] << 8) | response[1]

        return instruction


    def read_fsmstate(self):

        response = self.send_command(0x12, 2)

        print(f"Received: {response!r}")

        if len(response) != 2:
            return None

        if response[0] != 0x92:
            return None

        return response[1]

    

    def close(self):

        if self.ser.is_open:
            self.ser.close()