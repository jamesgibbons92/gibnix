{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    wf-recorder
    slurp
    ffmpeg
  ];

  home.file."screen-capture/.keep".text = "";

  # Screen capture script for recording screen regions to WebP
  home.file.".local/bin/screen-capture.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      # screen-capture.sh - Start/stop screen recording and convert to WebP

      DIR="$HOME/screen-capture"

      # Check whether to start or stop the recording (if wf-recorder is running)
      if [ -f /tmp/wf-recorder.pid ] && [ -f /tmp/wf-recorder.timestamp ]; then
          # Read the PID and timestamp of wf-recorder
          pid=$(cat /tmp/wf-recorder.pid)
          timestamp=$(cat /tmp/wf-recorder.timestamp)
          kill $pid
          rm /tmp/wf-recorder.pid /tmp/wf-recorder.timestamp

          # Send a notification
          notify-send "Recording Finished" \
                      "Converting..."

          # Convert the recording to webp
          output_path="$DIR/recording_''${timestamp}.webp"
          ffmpeg -i "$DIR/recording_''${timestamp}.mkv" \
                 -vf "fps=20,scale=-1:-1:flags=lanczos" \
                 -c:v libwebp -q:v 30 -loop 0 \
                 -preset default -an -vsync 0 -slices 4 "$output_path"

          # Remove mkv file
          rm "$DIR/recording_''${timestamp}.mkv"

          # Send a notification
          notify-send "Converting Finished" \
                      "Saved to $output_path"
      else
          # Generate a timestamp
          timestamp=$(date +"%Y%m%d_%H%M%S")

          # Create output dir if not exists
          mkdir -p $DIR

          # Start recording with wf-recorder and save to a file with the timestamp
          wf-recorder -g "$(slurp)" -f "$DIR/recording_''${timestamp}.mkv" &

          # Save the PID of wf-recorder and the timestamp
          echo $! > /tmp/wf-recorder.pid
          echo $timestamp > /tmp/wf-recorder.timestamp

          # Send a notification
          notify-send "Recording Started" \
                      "Saved to $DIR/recording_''${timestamp}.mkv"
      fi
    '';
  };

  wayland.windowManager.hyprland.settings.bind = [
    "$mainMod, R, exec, $HOME/.local/bin/screen-capture.sh"
  ];
}
