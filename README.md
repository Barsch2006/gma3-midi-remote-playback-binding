# GrandMA3 Plugin Assign Midi Remotes to Executors

Small abstractions for my specific use case of the [GrandMA3 Midi Executors Plugin by @Lenschcode](https://github.com/lenschcode/gma3-midi-executors)

## Usage

1. Add the plugin to your GrandMA3 showfile (I suggest you know what you are doing if you are using this)
2. Assign your Macros, Sequences, etc. to your Playbacks
3. Create a Midi Remote for each Macros/ Sequences/ etc. you want to control with Midi
4. Add a note to each Midi Remote with the following format: `Target: <Page>.<Executor> <Key or Fader>`
5. Run the plugin after each change of the page

The plugin will automatically configure the `target`, `key` and `fader` column of the Midi Remote to the values you gave your Macro/ Sequence/ etc. in the Playbacks.
The plugin will enable and disable the Midi Remote based on the page you are currently on.

## Notes

-   All Midi remotes without a page are assigned to every page
-   Locking the Midi Remotes will prevent the plugin from changing it's assignment
