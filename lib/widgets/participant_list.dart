import 'package:flutter/material.dart';

class ParticipantList extends StatelessWidget {
  final List<Map<String, String>> participants;

  const ParticipantList({super.key, required this.participants});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: participants.length,
      itemBuilder: (context, index) {
        final participant = participants[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
          child: ListTile(
            leading: CircleAvatar(
              child: Text(participant['name']![0]),
            ),
            title: Text(participant['name'] ?? ''),
            subtitle: Text('Status: ${participant['status']}'),
            trailing: const Icon(Icons.check_circle, color: Colors.green),
          ),
        );
      },
    );
  }
}