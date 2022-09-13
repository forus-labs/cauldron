class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TodayViewModel>();
    final date = viewModel.selectedDate.value;
    return Header.main(
      title: viewModel.header,
      details: HeaderIcon(
        icon: SvgIcons.application.plus,
        onPressed: Sheet.of(
          context: context,
          title: 'Add Entry',
          backgroundColor: context.styles.middleground.color,
          content: ,
        ),
      ),
    );
  }
}

List<T> between<T>(List<T> list, {required List<T> insert}) => [];

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TodayViewModel>();
    final date = viewModel.selectedDate.value;
    return Header.main(
      title: viewModel.header,
      details: HeaderIcon(
        icon: SvgIcons.application.plus,
        onPressed: Sheet.of(
          context: context,
          title: 'Add Entry',
          backgroundColor: context.styles.middleground.color,
          content: [
            _SheetOption(
              title: 'Journal',
              asset: assets.SvgIcons.prompt.journal,
              color: context.style(const Color(0xFFD9D1FF)).color,
              onPressed: () => context.pushRoute(
                EditJournalRoute(
                  record: JournalRecord(date: date, time: date),
                  type: EditType.create,
                ),
              ),
            ),
            const SizedBox(height: 13),
            _SheetOption(
              title: 'Media',
              asset: assets.SvgIcons.prompt.media,
              color: context.style(const Color(0xFFFFE1E3)).color,
              onPressed: () => context.pushRoute(
                EditMediaRoute(
                  record: MediaRecord(date: date, time: date),
                  type: EditType.create,
                ),
              ),
            ),
            const SizedBox(height: 13),
            _SheetOption(
              title: 'Mood',
              asset: assets.SvgIcons.prompt.mood,
              color: context.style(const Color(0xFFDCECFF)).color,
              onPressed: () => context.pushRoute(
                EditMoodRoute(
                  record: MoodRecord(date: date, time: date),
                  type: EditType.create,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}