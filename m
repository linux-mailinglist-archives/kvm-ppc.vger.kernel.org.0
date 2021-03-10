Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE10333264
	for <lists+kvm-ppc@lfdr.de>; Wed, 10 Mar 2021 01:31:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231504AbhCJAbO (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 9 Mar 2021 19:31:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231324AbhCJAam (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 9 Mar 2021 19:30:42 -0500
Received: from mail-io1-xd4a.google.com (mail-io1-xd4a.google.com [IPv6:2607:f8b0:4864:20::d4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92EB2C06174A
        for <kvm-ppc@vger.kernel.org>; Tue,  9 Mar 2021 16:30:42 -0800 (PST)
Received: by mail-io1-xd4a.google.com with SMTP id w8so11627539iox.13
        for <kvm-ppc@vger.kernel.org>; Tue, 09 Mar 2021 16:30:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=1BcHrgVIevscHGOPbP9Sxwife20LoA3ZZqd9CRbz5Bw=;
        b=DKv71NfHgZl9K+3WTTgnMIMFhTJhw0KdiZ+0DsSSoWMbruSU8JYpotmsteHcMpFnKP
         p3oJl9d7poG/uNqx9QVjZxRsDg84eU0xeqR/z3zNbVYX8v/8Pqaq2D2o6XtuLtoQIAWn
         XZIko6RjucQT9l8eCAbgMb2o84jv4v0MYqAUW+gbWQ/6DAdn7cgT09hkIvc7uvV40U3/
         OXNI1psrB1fZwZO3xGQK35hCSkEnWUaO1l3/peXbxmeOQdZwn1Qj3XsVRuxh8uptWwNf
         ZpoGFHSOUGyGujS8e+ldyI4tL/z2BcdRYhlTSsMqOPaw7n36OXxIcUJIiplu0hMkQaNX
         IFPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=1BcHrgVIevscHGOPbP9Sxwife20LoA3ZZqd9CRbz5Bw=;
        b=bZ4c100r6Ef6qaVmudYx6jIz6BGsdZc+ENZAem10TwadsLc2IcJGiKsfumy6FZw/kN
         8fl8bgM+pcGRAp7qImJFUHoR6hbG8BwJfiozImszoBCL9kHI9JCpSbcDcktNEfs6jttL
         s6sc7ats1JvwNfmXe/aaKj1iKHnW0KWFOeyTz1fT/nFhMiHOws3/IjsuxMbZOZ6era5i
         FkHVVaOIonW/L/iI3Uhc8GcfiN2zZaFqzkqSnGWNDiswO3cVHkLIIgMYSgtxBx1BEkty
         lc5LcRrbMp6bALF94TXA4arQ4BAmu22wDhsUbjOj9g9SAi4rcTytNT6fFRobj++ilgTY
         9/ug==
X-Gm-Message-State: AOAM533ACIvkqRXjv+JJ2O53QaUlM2OyZXU81oKEt2wBOXL/bYn0boQQ
        R2NmGtEIYB34GGKkLl5iUFpZkyv1EEL4hiVz3A==
X-Google-Smtp-Source: ABdhPJzu6oYBav/oVxbZg4DkYFlYy8mfxqu7QjB5WE/gplPDgic3NrLr6r8qLWmnqz7/bt/7iNP/OuQ+NB4k0O9fnQ==
X-Received: from jingzhangos.c.googlers.com ([fda3:e722:ac3:10:2b:ff92:c0a8:513])
 (user=jingzhangos job=sendgmr) by 2002:a92:b00d:: with SMTP id
 x13mr708430ilh.128.1615336242003; Tue, 09 Mar 2021 16:30:42 -0800 (PST)
Date:   Wed, 10 Mar 2021 00:30:20 +0000
Message-Id: <20210310003024.2026253-1-jingzhangos@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [RFC PATCH 0/4] KVM: stats: Retrieve statistics data in binary format
From:   Jing Zhang <jingzhangos@google.com>
To:     KVM <kvm@vger.kernel.org>, KVM ARM <kvmarm@lists.cs.columbia.edu>,
        Linux MIPS <linux-mips@vger.kernel.org>,
        KVM PPC <kvm-ppc@vger.kernel.org>,
        Linux S390 <linux-s390@vger.kernel.org>,
        Linux kselftest <linux-kselftest@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        David Rientjes <rientjes@google.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>
Cc:     Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This patchset extends IOCTL interface to retrieve KVM statistics data
in aggregated binary format.
It is meant to provide a lightweight, flexible, scalable and efficient 
lock-free solution for userspace telemetry applications to pull the
statistics data periodically for large scale systems.
The capability is indicated by KVM_CAP_STATS_BINARY_FORM.
Ioctl KVM_STATS_GET_INFO is used to get the information about VM or
vCPU statistics data (The number of supported statistics data which is
used for buffer allocation).
Ioctl KVM_STATS_GET_NAMES is used to get the list of name strings of
all supported statistics data.
Ioctl KVM_STATS_GET_DATA is used to get the aggregated statistics data
per VM or vCPU in the same order as the list of name strings. This is
the ioctl which would be called periodically to retrieve statistics
data per VM or vCPU.

Jing Zhang (4):
  KVM: stats: Separate statistics name strings from debugfs code
  KVM: stats: Define APIs for aggregated stats retrieval in binary
    format
  KVM: stats: Add ioctl commands to pull statistics in binary format
  KVM: selftests: Add selftest for KVM binary form statistics interface

 Documentation/virt/kvm/api.rst                |  79 +++++
 arch/arm64/kvm/guest.c                        |  47 ++-
 arch/mips/kvm/mips.c                          | 114 +++++--
 arch/powerpc/kvm/book3s.c                     | 107 ++++--
 arch/powerpc/kvm/booke.c                      |  84 +++--
 arch/s390/kvm/kvm-s390.c                      | 320 ++++++++++++------
 arch/x86/kvm/x86.c                            | 127 ++++---
 include/linux/kvm_host.h                      |  30 +-
 include/uapi/linux/kvm.h                      |  60 ++++
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   3 +
 .../selftests/kvm/kvm_bin_form_stats.c        |  89 +++++
 virt/kvm/kvm_main.c                           | 115 +++++++
 13 files changed, 935 insertions(+), 241 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/kvm_bin_form_stats.c


base-commit: 357ad203d45c0f9d76a8feadbd5a1c5d460c638b
-- 
2.30.1.766.gb4fecdf3b7-goog

