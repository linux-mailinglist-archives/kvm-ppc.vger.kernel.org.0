Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E34982C7222
	for <lists+kvm-ppc@lfdr.de>; Sat, 28 Nov 2020 23:06:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387859AbgK1VuZ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 28 Nov 2020 16:50:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732410AbgK1TAU (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sat, 28 Nov 2020 14:00:20 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6835EC09424E
        for <kvm-ppc@vger.kernel.org>; Fri, 27 Nov 2020 23:07:37 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id w4so5987608pgg.13
        for <kvm-ppc@vger.kernel.org>; Fri, 27 Nov 2020 23:07:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=80cZRa6DY2WJtqGfVyPLANbeYfDEscKkkay6pVYA2aQ=;
        b=l3+syg2Mf4aw053csQE+dTDInc4SFZIuTep1XdzIvXF4HINeegyBlT2ZTRf0ReZqLj
         YY3FlHpkOaD07EJs6A1PI86wlGE6JN2mvHhy42klYIHmQDg0lssh453QEMokyVdf1ss8
         IdbctNhfc0LZnXEuQzgyx+I0jPEdeOPKcj9LKGFe+ZYXqg0DEzWwNBmXOW7d4Pxpufhe
         otZVO+jiIHX6HB5Hr8D1DLqySpJagjXP/us3YKWjysZBGwPNhexy5nXs2E4b5KuhDLxp
         A98mcym3+DSrAibkM23qNGVjh3Sn3NXaOi2cT7sOQBWKlTaow21RE3WlEtfeyPJl6nfe
         cuRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=80cZRa6DY2WJtqGfVyPLANbeYfDEscKkkay6pVYA2aQ=;
        b=F9C239ZCoEYmyHAAiIuAxNDiacX27kxPPa8FfndLL9swczOcnn3+M7Q1uCQjT3iuOa
         PFZRcySUxogQNzt3EVhquvQNZPwr7BhEGliICd3ThyBxTuZehqXuAiFSUtQXf22SZUds
         A0lojYkZxrDyNnYvCou53YIKvMnzdUqggcfay4Lxdu0904d0eFhbAEptmwuiV+PyypUY
         LkCcjlbu2EERKqkNg7gs74RijjFmaWRLF0yGuq9KrsfVta+OqTvg4AvtqPCpJA4nYWfl
         i7Ce2tht3YhVQlGUMYilLCna/B7F8f0sU4hzO+BuTymxdKJkS37pEqREa/fcueqoeKIa
         XYVA==
X-Gm-Message-State: AOAM530zyq3RdPmahhM3jQBi78e4/WIjUFo+thiRBt0f8QPivQesIykp
        /V5Mw8QDlS0iOLpjcSCIAhM=
X-Google-Smtp-Source: ABdhPJwRVGY1ubWi9/oculm+y+cZpPgZ6MjJ6LYtHmHgoMkGoa9EVXg42FeReeIgzv6AAjk983t8yQ==
X-Received: by 2002:a65:44c2:: with SMTP id g2mr4925662pgs.256.1606547256927;
        Fri, 27 Nov 2020 23:07:36 -0800 (PST)
Received: from bobo.ibm.com (193-116-103-132.tpgi.com.au. [193.116.103.132])
        by smtp.gmail.com with ESMTPSA id e31sm9087329pgb.16.2020.11.27.23.07.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2020 23:07:36 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, kvm-ppc@vger.kernel.org,
        Mahesh Salgaonkar <mahesh@linux.ibm.com>
Subject: [PATCH 0/8] powerpc/64s: fix and improve machine check handling
Date:   Sat, 28 Nov 2020 17:07:20 +1000
Message-Id: <20201128070728.825934-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

First patch is a nasty memory scribble introduced by me :( That
should go into fixes.

The next ones could wait for next merge window. They get things to the
point where misbehaving or buggy guest isn't so painful for the host,
and also get the guest SLB dumping code working (because the host no
longer clears them before delivering the MCE to the guest).

I have a crasher guest vmlinux with a few SLB handling bugs introduced
which now bumbles along okay without bothering the host so much.

I don't know what the picture or high level strategy really is for UE
memory errors in the guest, particularly with PowerVM, so some review
there would be good (I haven't changed anything really in that space
AFAIKS, but as an overall "is this the right way to go" kind of thing).

Thanks,
Nick

Nicholas Piggin (8):
  powerpc/64s/powernv: Fix memory corruption when saving SLB entries on
    MCE
  powerpc/64s/powernv: Allow KVM to handle guest machine check details
  KVM: PPC: Book3S HV: Don't attempt to recover machine checks for FWNMI
    enabled guests
  KVM: PPC: Book3S HV: Ratelimit machine check messages coming from
    guests
  powerpc/64s/powernv: ratelimit harmless HMI error printing
  powerpc/64s/pseries: Add ERAT specific machine check handler
  powerpc/64s: Remove "Host" from MCE logging
  powerpc/64s: tidy machine check SLB logging

 arch/powerpc/include/asm/mce.h            |  1 +
 arch/powerpc/kernel/mce.c                 |  4 +-
 arch/powerpc/kernel/mce_power.c           | 98 +++++++++++++----------
 arch/powerpc/kvm/book3s_hv.c              | 11 ++-
 arch/powerpc/kvm/book3s_hv_ras.c          | 23 ++++--
 arch/powerpc/mm/book3s64/slb.c            | 39 ++++-----
 arch/powerpc/platforms/powernv/opal-hmi.c | 27 ++++---
 arch/powerpc/platforms/powernv/setup.c    |  9 ++-
 arch/powerpc/platforms/pseries/ras.c      |  5 +-
 9 files changed, 129 insertions(+), 88 deletions(-)

-- 
2.23.0

