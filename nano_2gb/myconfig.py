CAMERA_TYPE = "CSIC"   # (PICAM|WEBCAM|CVCAM|CSIC|V4L|D435|MOCK|IMAGE_LIST)
IMAGE_W = 224
IMAGE_H = 224

CSIC_CAM_GSTREAMER_FLIP_PARM = 2 # (0 => none , 4 => Flip horizontally, 6 => Flip vertically)

DRIVE_TRAIN_TYPE = "MM1" # SERVO_ESC|DC_STEER_THROTTLE|DC_TWO_WHEEL|SERVO_HBRIDGE_PWM|PIGPIO_PWM|MM1|MOCK

JOYSTICK_MAX_THROTTLE = 1   
JOYSTICK_DEADZONE = 0.01
CONTROLLER_TYPE='F710'  


MM1_STEERING_MID = 1500         # Adjust this value if your car cannot run in a straight line
MM1_MAX_FORWARD = 1630          # Max throttle to go fowrward. The bigger the faster
MM1_STOPPED_PWM = 1500
MM1_MAX_REVERSE = 1270          # Max throttle to go reverse. The smaller the faster
MM1_SERIAL_PORT = '/dev/ttyTHS1'  # Serial Port for reading and sending MM1 data.
