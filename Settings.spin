CON

  {{Pin Definitions}}

  ADC_SPIN                      = 0
  ADC_DPIN                      = 1
  ADC_CPIN                      = 2  

  ESCON_LEFT_SPEED              = 3
  ESCON_LEFT_CW                 = 4
  ESCON_LEFT_CCW                = 5

  ESCON_RIGHT_SPEED             = 6
  ESCON_RIGHT_CW                = 7
  ESCON_RIGHT_CCW               = 8

  ESCON_ARM_SPEED               = 9
  ESCON_ARM_CW                  = 10
  ESCON_ARM_CCW                 = 11  

  BUTTON_TOP                    = 12
  BUTTON_BOTTOM                 = 13

  CMUCAM_TX                     = 15
  CMUCAM_RX                     = 14

  BLUETOOTH_TX                  = 16
  BLUETOOTH_RX                  = 17
  
  SERVO_SIGNAL                  = 19
  LAMP_SIGNAL                   = 20
  PING_SIGNAL                   = 21

  IMU_SCL                       = 22
  IMU_SDA                       = 23

  {{CMUCam}}

        {{CMUCam Calibration}}
  
        CMUCAM_MODIFIER               = 0
        CMUCAM_BLACK_RED_BOTTOM       = 0
        CMUCAM_BLACK_RED_TOP          = 170
        CMUCAM_BLACK_GREEN_BOTTOM     = 0 
        CMUCAM_BLACK_GREEN_TOP        = 255
        CMUCAM_BLACK_BLUE_BOTTOM      = 0
        CMUCAM_BLACK_BLUE_TOP         = 255
        CMUCAM_BLACK_BRIGHTNESS       = 0
        CMUCAM_BLACK_CONTRAST         = 15
        CMUCAM_BLACK_NOISE_FILTER     = 0
        CMUCAM_GREEN_RED_BOTTOM       = 90  'ST 90 150 140 200 120 180
        CMUCAM_GREEN_RED_TOP          = 150
        CMUCAM_GREEN_GREEN_BOTTOM     = 140
        CMUCAM_GREEN_GREEN_TOP        = 200
        CMUCAM_GREEN_BLUE_BOTTOM      = 120
        CMUCAM_GREEN_BLUE_TOP         = 180
        CMUCAM_GREEN_BRIGHTNESS       = 0
        CMUCAM_GREEN_CONTRAST         = -5
        CMUCAM_GREEN_NOISE_FILTER     = 0

        {{CMUCam Lamp}}
         
        CMUCAM_LAMP_LOW               = 20
        CMUCAM_LAMP_MEDIUM            = 50
        CMUCAM_LAMP_HIGH              = 100

  X_RES                         = 160
  Y_RES                         = 120
  X_MIDPOINT                    = X_RES/2
  Y_MIDPOINT                    = Y_RES/2

  {{Motors}}

  LEFT_MAX_SPEED                = 100 
  RIGHT_MAX_SPEED               = 100

  PWM_DUTY_BOTTOM               = 30  
  PWM_DUTY_TOP                  = 90                                                

  {{ADC Settings}}

  ADC_MODE                      = 255

  {{Bluetooth Settings}}

  BTOOTH_BAUD                   = 115_200

  {{IMU Settings}}

  IMU_ADDR                      = $1E

  {{Line Following Algorithm}}

  JUNCTION_BLK_PIXEL_SATURATION = 200
  JUNCTION_GRN_PIXEL_SATURATION = 17

  GOAL_SPEED = 35
  X_SCALE = 40
  

  {{Water Tower}}

  TOWER_IR_ADJUST_THRESHOLD     = 300

  {{Constants}}

  CONVERTER_CONSTANT            = 10_000                        
  LEFT                          = 1
  RIGHT                         = 2

  {{PID Settings}}


PUB Main