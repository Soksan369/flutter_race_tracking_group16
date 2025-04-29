import 'package:flutter/material.dart';
import '../../data/models/participant.dart';

class ParticipantListItem extends StatelessWidget {
  final Participant participant;
  final VoidCallback onComplete;

  const ParticipantListItem({
    super.key,
    required this.participant,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          children: [
            // Bib number circle
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                participant.bib.toString(),
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Name
            Expanded(
              child: Text(
                participant.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
            // Finish button
            participant.completed
                ? const Chip(
                    label: Text(
                      'Finished',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 4),
                  )
                : ElevatedButton(
                    onPressed: onComplete,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF4CD964), // Exact green from image
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      minimumSize: const Size(80, 36),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 0),
                    ),
                    child: const Text(
                      'Finish',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
