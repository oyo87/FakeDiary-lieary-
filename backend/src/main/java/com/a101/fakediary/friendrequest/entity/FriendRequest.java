package com.a101.fakediary.friendrequest.entity;

import com.a101.fakediary.common.BaseEntity;
import com.a101.fakediary.enums.ERequestStatus;
import com.a101.fakediary.member.entity.Member;
import lombok.*;

import javax.persistence.*;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
public class FriendRequest extends BaseEntity {
    @SequenceGenerator(
            name = "FRIEND_REQUEST_SEQ_GEN",
            sequenceName = "FRIEND_REQUEST_SEQ",
            initialValue = 100,
            allocationSize = 1
    )
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "FRIEND_REQUEST_GEN")
    private Long friendRequestId;

    @ManyToOne
    @JoinColumn(name = "sender_id", referencedColumnName = "member_id", nullable = false)
    private Member senderId;

    @ManyToOne
    @JoinColumn(name = "receiver_id", referencedColumnName = "member_id", nullable = false)
    private Member receiverId;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", length = 20,nullable = false)
    private ERequestStatus status;




}
