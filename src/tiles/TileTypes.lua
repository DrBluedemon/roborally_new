FLOOR = 1
HOLE = 2
SLOW_CONVEYERS = 3
FAST_CONVEYERS = 4
VOID = 5
CHECKPOINTS = 6
SPAWNPOINTS = 7
REPAIRSTATION_ONE = 8
REPAIRSTATION_TWO = 9
WHEN_TRIGGERS = 10
SPINER_LEFT = 11
SPINER_RIGHT = 12
LASER_SHOOT_ONE = 13
LASER_SHOOT_TWO = 14
LASER_BEAM_ONE = 15
LASER_BEAM_ONE_CROSS = 16
LASER_BEAM_TWO = 17
LASER_BEAM_TWO_CROSS = 18
PUSHER_WALL = 19
PUSHER_HANDLE = 20
PUSHER_HEAD = 21
SELECTION_BOX = 22
WALL = 23
WALL_CORNER = 24

TURN_LEFT = 1
TURN_RIGHT = 2
FORWARD = 3
JUNKTION_OUT = 4
JUNKTION_IN_LEFT = 5
JUNKTION_IN_RIGHT = 6

SPAWN_1 = 1
SPAWN_2 = 2
SPAWN_3 = 3
SPAWN_4 = 4
SPAWN_5 = 5
SPAWN_6 = 6
SPAWN_7 = 7
SPAWN_8 = 8



TILE_TYPES = {
    [FLOOR] = 0,
    [HOLE] = 1,

    [SLOW_CONVEYERS] = {
        [1] = 16,
        [2] = 17,
        [3] = 24,
        [4] = 25,
        [5] = 32,
        [6] = 33
    },

    [FAST_CONVEYERS] = {
        [1] = 40,
        [2] = 48,
        [3] = 56,
        [4] = 41,
        [5] = 49,
        [6] = 57
    },

    [VOID] = {
        [1] = 50,
        [2] = 58,
        [3] = 51,
        [4] = 52,
        [5] = 59,
        [6] = 60
    },

    [CHECKPOINTS] = {
        [1] = 18,
        [2] = 26,
        [3] = 34,
        [4] = 42
    },

    [SPAWNPOINTS] = {
        [1] = 4,
        [2] = 5,
        [3] = 6,
        [4] = 7,
        [5] = 12,
        [6] = 13,
        [7] = 14,
        [8] = 15
    },

    [REPAIRSTATION_ONE] = 3,
    [REPAIRSTATION_TWO] = 2,

    [WHEN_TRIGGERS] = {
        [1] = 19,
        [2] = 27,
        [3] = 35,
        [4] = 43,
        [5] = 20
    },

    [SPINER_LEFT] = 10,
    [SPINER_RIGHT] = 11,

    [LASER_SHOOT_ONE] = 53,
    [LASER_SHOOT_TWO] = 61,
    [LASER_BEAM_ONE] = 54,
    [LASER_BEAM_ONE_CROSS] = 55,
    [LASER_BEAM_TWO] = 47,
    [LASER_BEAM_TWO_CROSS] = 46,

    [PUSHER_WALL] = 31,
    [PUSHER_HANDLE] = 23,
    [PUSHER_HEAD] = 22,

    [SELECTION_BOX] = 28,
    [WALL] = 62,
    [WALL_CORNER] = 63
}
