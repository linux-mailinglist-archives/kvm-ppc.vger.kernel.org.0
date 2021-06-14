Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ECFA3A5BA8
	for <lists+kvm-ppc@lfdr.de>; Mon, 14 Jun 2021 04:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232330AbhFNC4P (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 13 Jun 2021 22:56:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232295AbhFNC4O (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 13 Jun 2021 22:56:14 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3606EC061574
        for <kvm-ppc@vger.kernel.org>; Sun, 13 Jun 2021 19:53:58 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id c20-20020a621c140000b02902e9c6ad8cd9so7461452pfc.16
        for <kvm-ppc@vger.kernel.org>; Sun, 13 Jun 2021 19:53:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=KV1G/R1zSZnSBOo/d7pZSYrqkdhyWDQYDOJ/O2SNH4I=;
        b=kDQEan3QS0HPXWg18LBV2T73SvgN3datzG2XhzaYhgiNgGasOyWf+QJstJsHVasjiW
         IHzlsrAC3QKbwWnobFjsw5ahQCrYI/z+Eo/XT8EEnOSRC18yfBYktADbFbSlLHQ8S6Iw
         FC1ltJ7DqfFoJxfTz4aD7EnlxksQ3aTdcI+rmyvgj4Idgh7lZb28q+rwNp514TO/722o
         f1nR3FVWQj/6t9gKh5sJslnMeKt8oNOfdNRsCkZ7xtm1Vvrk1lrdi+9qJSxpgju6r2Gl
         QRdTdil4be1AJmPnHhHxQ1VFA3c7XtQ0+pzairSTsOJ16N0IKcg1ppAD/RbQQIrPznYI
         RjGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=KV1G/R1zSZnSBOo/d7pZSYrqkdhyWDQYDOJ/O2SNH4I=;
        b=kXXhKn4QMImc9YW++tzMxOmVJB2ART0UB/FML3Lbr1tTxH9GDyiGTjHCBXWvYtngFO
         mRTzLsQ1P1dPDBMlqzBAkt0i2tGDgithCWHH17Qm78mHxrW6rxhnKoZu5qDyre2iTN/H
         gW3H997+4ZcjNUU7LS5k+IvElyf4HE1KOe2FsILOABK4q6axIUTZ67KbuIH5peUjaNpo
         wkxFbAMSGKeGFgNHnGpbJjQeTEDLKC3gyb8bafDnmiSmhEpBvUWc9hfgP+AFGrqgFKyb
         afiAKvk/kUol/gYTJhAHKeuP8IclQ4tUQPyFkvJqTwttyMlw4e+KezOwFBcnmDRLwtSs
         hiLg==
X-Gm-Message-State: AOAM533P26wa0BuvayoFjbWCa6OP/Fdemn2/1C/xSevBINuXxGR9EFkP
        5+dem7eHeyTWIbg/BeMnApnPh2yWpGf/4pamjg==
X-Google-Smtp-Source: ABdhPJwRWAstHgo7BVtHEtkFzdNcfslZh+/1MjQ4teaqitIxKeI6I2u0l+pkFtjTmd38Dt65Uu2PIUcSDoZnRDqISg==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:902:9008:b029:119:25dd:8646 with
 SMTP id a8-20020a1709029008b029011925dd8646mr10986859plp.41.1623639235855;
 Sun, 13 Jun 2021 19:53:55 -0700 (PDT)
Date:   Mon, 14 Jun 2021 02:53:47 +0000
Message-Id: <20210614025351.365284-1-jingzhangos@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
Subject: [PATCH 0/4] Remove duplicated stats definitions for debugfs
From:   Jing Zhang <jingzhangos@google.com>
To:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>,
        LinuxMIPS <linux-mips@vger.kernel.org>,
        KVMPPC <kvm-ppc@vger.kernel.org>,
        LinuxS390 <linux-s390@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Fuad Tabba <tabba@google.com>
Cc:     Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This is a follow-up patchset to binary stats interface patchset as below:
https://lore.kernel.org/kvm/20210611124624.1404010-1-jingzhangos@google.com

This patchset contains a commit to fix some missing stats and add static
check to make sure we have the right number of stats descriptors and add an
'offset' field in stats descriptor to make sure the or order of stats
descriptors is not relevant to the order of stats in vm/vcpu stats
structure. This will totally avoid the possibility of missing stats and
mismatched stats definitions.

The binary stats interface defines stats in another array of descriptors,
while the original stats debugfs interface uses array of kvm_stats_debugfs
item. To remove the duplicated stats definition, this patchset would
utilize only the stats descriptors to provide stats information to debugfs
interface. This patchset adds a 'mode' flag to support the read/write mode
of stats, which can be used to indicate the file permission of debugfs
stats files. It removes the usage of kvm_stats_debugfs_item and all the
debugfs_entries defined in all archs.

The patch also fixes an issue that read only stats could be cleared in
global level, though not permitted in VM level in the original debugfs
code.

---

Jing Zhang (4):
  KVM: stats: Make sure no missing or mismatched binary stats definition
  KVM: stats: Use binary stats descriptors for debugfs interface
  KVM: stats: Update documentation supporting stats mode and offset
  KVM: selftests: Update binary stats test for stats mode

 Documentation/virt/kvm/api.rst                |  33 +-
 arch/arm64/kvm/guest.c                        |  32 +-
 arch/mips/kvm/mips.c                          |  99 ++----
 arch/powerpc/kvm/book3s.c                     | 101 ++----
 arch/powerpc/kvm/booke.c                      |  79 ++---
 arch/s390/kvm/kvm-s390.c                      | 307 ++++++------------
 arch/x86/kvm/x86.c                            | 120 +++----
 include/linux/kvm_host.h                      | 186 ++++++-----
 include/uapi/linux/kvm.h                      |  11 +-
 .../selftests/kvm/kvm_binary_stats_test.c     |  13 +-
 virt/kvm/kvm_main.c                           | 105 ++++--
 11 files changed, 477 insertions(+), 609 deletions(-)


base-commit: 39be2e28180a2e87af5fbb8d83643812e1a3b371
-- 
2.32.0.272.g935e593368-goog

