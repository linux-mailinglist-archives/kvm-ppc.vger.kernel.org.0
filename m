Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 297F735B83C
	for <lists+kvm-ppc@lfdr.de>; Mon, 12 Apr 2021 03:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236248AbhDLBtZ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 11 Apr 2021 21:49:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235543AbhDLBtY (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 11 Apr 2021 21:49:24 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5609C061574
        for <kvm-ppc@vger.kernel.org>; Sun, 11 Apr 2021 18:49:07 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id t22so5196934ply.1
        for <kvm-ppc@vger.kernel.org>; Sun, 11 Apr 2021 18:49:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aPW9xuVZJZuCiDrYNQXotx3oRG9X3McxReJTO2kC5og=;
        b=SYWY0d3oAkHA3HQIL62Nqb0zxyIXpk49D+FvlZFrRHC8iiKzs7iIbjSkYcWrt1UCwc
         g4FJ3SDPh+7EpWhSOmC1mM74DIPF329C11OpaoPO94H5XH/nJhpM6g5octHAdEcO61qt
         aIT3bRA3lGXrFJIpN/YdDtcrmMqKuXB1wxPOeebU9m4ZkmckrpYITI5Pg/qDK37Lf+qQ
         cg5JU0MwFiT6+fN9b7hdJRdrjMz/8H1vvD0dFfgeb5thcGI+1x0v8u1AsXxVjs2jk3fO
         gi18DfyAAncd7ZcpG6sdiTfTvPJBRf0fpZ9SJnTJ2494KmsTEi1uivVitDlwHETY8Qbz
         Hlkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aPW9xuVZJZuCiDrYNQXotx3oRG9X3McxReJTO2kC5og=;
        b=oGmIICoCWJF251XUVhWcVIeB77+JcbwseYmwHdxqTVaIDTfTev/RH9fKiAsS/WErng
         o03vYPKEHPCV78LNuhiQn31sJtP8zhr0TxHqLZrjttpXEM0ZmSOrmRslFSzwsBz9S9qF
         y2Ry9zgtOP6cnGDKYR/mBGXFcvJTMvFtg1wfBjV+H5jBtGjEiYwX1civvKVR65mBQkE0
         OT9jzRlcoegpvtG6zqFOF830FvCd9B8bfznZ6d098IIDp4FRad7+ZS7tcQ4NYUIP8iQz
         h4v+J+G5LWhMC9OaYhXQXjEPl0uu/GhyQWAYhXRCg0uhKUaeaxvSpQg0fy1LAc1NyU3B
         fdGw==
X-Gm-Message-State: AOAM531ksg1s/CSEMigg5oAmHl8WNk4YC/zsp2rH4bStxFv6FIRG17dZ
        cUiVPTz6p3IyLGT44Wq/Z60YEDG3v0c=
X-Google-Smtp-Source: ABdhPJy8SNqNyFIyV1FVhMCiP8rj7Natlar2xhV5RA3NVM+u7+4+x0Ghsb4SrJTOVJ0aBVfaYEgdtg==
X-Received: by 2002:a17:90a:b10a:: with SMTP id z10mr1835470pjq.161.1618192147216;
        Sun, 11 Apr 2021 18:49:07 -0700 (PDT)
Received: from bobo.ibm.com (193-116-90-211.tpgi.com.au. [193.116.90.211])
        by smtp.gmail.com with ESMTPSA id m9sm9502345pgt.65.2021.04.11.18.49.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Apr 2021 18:49:07 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH v1 05/12] KVM: PPC: Book3S HV: Prevent radix guests setting LPCR[TC]
Date:   Mon, 12 Apr 2021 11:48:38 +1000
Message-Id: <20210412014845.1517916-6-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210412014845.1517916-1-npiggin@gmail.com>
References: <20210412014845.1517916-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Prevent radix guests setting LPCR[TC]. This bit only applies to hash
partitions.

Reviewed-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 3de8a1f89a7d..70c6e9c27eb7 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -1645,6 +1645,10 @@ static int kvm_arch_vcpu_ioctl_set_sregs_hv(struct kvm_vcpu *vcpu,
  */
 unsigned long kvmppc_filter_lpcr_hv(struct kvm *kvm, unsigned long lpcr)
 {
+	/* LPCR_TC only applies to HPT guests */
+	if (kvm_is_radix(kvm))
+		lpcr &= ~LPCR_TC;
+
 	/* On POWER8 and above, userspace can modify AIL */
 	if (!cpu_has_feature(CPU_FTR_ARCH_207S))
 		lpcr &= ~LPCR_AIL;
-- 
2.23.0

