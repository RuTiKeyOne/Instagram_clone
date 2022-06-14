import 'package:flutter/material.dart';
import 'package:instagram_clone/generated/l10n.dart';
import 'package:instagram_clone/presentation/widgets/post_item/post_actions.dart';
import 'package:instagram_clone/presentation/widgets/post_item/post_description.dart';
import 'package:instagram_clone/presentation/widgets/post_item/post_header.dart';
import 'package:instagram_clone/presentation/widgets/post_item/post_photo_detector.dart';
import 'package:instagram_clone/presentation/widgets/post_item/view_all_container.dart';
import '../../../core/model/post.dart';
import 'date_published_container.dart';

class PostItem extends StatefulWidget {
  final Post post;
  final String userUid;
  final bool isLiked;
  final VoidCallback onLikePressed;
  final VoidCallback onNotLikePressed;
  final VoidCallback onMorePressed;
  final VoidCallback onCommentPressed;
  const PostItem({
    Key? key,
    required this.userUid,
    required this.onLikePressed,
    required this.onNotLikePressed,
    required this.onMorePressed,
    required this.isLiked,
    required this.onCommentPressed,
    required this.post,
  }) : super(key: key);

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  bool isLikeAnimating = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PostHeader(
          widget: widget,
          onMorePressed: () => widget.onMorePressed(),
        ),
        PostPhotoDetector(
          onLikeTap: () {
            if (!widget.post.likes.contains(widget.userUid)) {
              setState(() {
                isLikeAnimating = !isLikeAnimating;
                widget.onLikePressed();
              });
            }
          },
          imageUrl: widget.post.postUrl,
          isLikeAnimating: isLikeAnimating,
          onEndAnimation: () {
            setState(() {
              isLikeAnimating = false;
            });
          },
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 4, left: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PostActions(
                  isLiked: widget.post.likes.contains(widget.userUid),
                  onLikePressed: () {
                    widget.onLikePressed();
                    setState(() {
                      isLikeAnimating = !isLikeAnimating;
                    });
                  },
                  onNotLikePressed: () {
                    widget.onNotLikePressed();
                  }),
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PostDescription(widget: widget),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.post.likes.length} ${S.of(context).likes}',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ],
                ),
              ),
              ViewAllCommentsContainer(onTap: () => widget.onCommentPressed()),
              DatePublishedContainer(widget: widget),
            ],
          ),
        ),
      ],
    );
  }
}
