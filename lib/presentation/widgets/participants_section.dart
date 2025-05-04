import 'package:flutter/material.dart';
import '../../../data/models/participant.dart';
import 'participant_list_item.dart';

class ParticipantsSection extends StatelessWidget {
  final List<Participant> participants;
  final Function(String) onComplete;

  const ParticipantsSection({
    super.key,
    required this.participants,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Icon(Icons.people, size: 20),
                SizedBox(width: 8),
                Text(
                  'Participant',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: participants.length,
              itemBuilder: (context, index) {
                final participant = participants[index];
                return ParticipantListItem(
                  participant: participant,
                  onComplete: () => onComplete(participant.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
