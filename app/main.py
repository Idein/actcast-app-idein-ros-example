import rclpy
from rclpy.node import Node
from std_msgs.msg import String
import actfw_core


class MinimalSubscriber(Node):
    def __init__(self):
        super().__init__("minimal_subscriber")
        self.subscription = self.create_subscription(
            String,
            "chatter",
            self.listener_callback,
            10,  # QoS history depth
        )
        self.subscription  # prevent unused variable warning

    def listener_callback(self, msg):
        # print(f"Received: '{msg.data}'")
        actfw_core.notify([{"message": msg.data}])


def main(args=None):
    rclpy.init(args=args)
    node = MinimalSubscriber()

    try:
        rclpy.spin(node)
    except KeyboardInterrupt:
        pass

    node.destroy_node()
    rclpy.shutdown()


if __name__ == "__main__":
    main()
