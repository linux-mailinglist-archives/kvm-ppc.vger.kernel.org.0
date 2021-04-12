Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7A4335B83D
	for <lists+kvm-ppc@lfdr.de>; Mon, 12 Apr 2021 03:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236249AbhDLBt2 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 11 Apr 2021 21:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235543AbhDLBt1 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 11 Apr 2021 21:49:27 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D27C0C061574
        for <kvm-ppc@vger.kernel.org>; Sun, 11 Apr 2021 18:49:10 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id r13so2013053pjf.2
        for <kvm-ppc@vger.kernel.org>; Sun, 11 Apr 2021 18:49:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cpb0XptfeBMEd7qKsPHT+YBhIbp2/2VOCByAd+xlm2w=;
        b=QkYMrAhT2zZNRUqAfP+TulXEuU+UstC9cxmsiDYerJmc2MhpzRX2wg4ls53EG2D8+V
         7h+m/ZWZMjNtANeJ/aFsXQKygp68Zfvsn686XeQHs+qlZSHfVRTnHN0hHkYUnCDz8jNN
         gohiOQHcRCcGMQtJ7dc/86F9o1NWeexOF3I88etqvFKJh03KgGNwGzkSSHGIjXJE5Ilq
         XsGSdMillDam8701eiEBTubhfA3751zVq+eiZVpR2Mp5MU2Tyju56DLrZKLeRDZz9JUD
         SaLUiSgSRKreQXpjrxexQBpZqHpyyE//+PzlmSvonJ6HfPlnBUuPgOSqWdXuSn0tApMo
         W+/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cpb0XptfeBMEd7qKsPHT+YBhIbp2/2VOCByAd+xlm2w=;
        b=DbNzOnL58V/ewZ4jb4xQr01NlxjXtlOI5IoR9vRQNFeVUM9WfiVCn9X2OWudHBNYyc
         eQDNBDDfQ2F6u7haZX/FnxQSYXQNs0h8RPNQPU4tRzxKVhf6nQoavs6vCKFWdmvmyWFZ
         hat/14eJxWqTqoQsb3qTnkNblwGJDIV9MvKStLITQTu0gEqAKPhdCu0t/0+lQBAczoNO
         31NxMs2csjbZQL8nxqlnxFz0x4BSomHyxry41lSHJDlEORkPZzdTOGwYlD71l/y3gUEz
         onEwGiY5bOE38A23xKL8z0nilUXrXBaThC6+47L7i790G07NA2ZKNFf+9dwLUiPT/rl4
         sqGg==
X-Gm-Message-State: AOAM531Y8Ft2tez/srwm1G1XinhQpRz38M2eLD9eabaRbD9YREkELBPa
        BMqmuKtLW+GdTV4tKZXVOD1MoQL1NI4=
X-Google-Smtp-Source: ABdhPJxUFVcm9udHXZivrKxIi7Y8tuEXU1lceLemYm3P4Efs1s+ojSOkkmJnlrqeco1bkvq2YzM2Lw==
X-Received: by 2002:a17:902:527:b029:ea:b5ef:689d with SMTP id 36-20020a1709020527b02900eab5ef689dmr10954544plf.19.1618192150372;
        Sun, 11 Apr 2021 18:49:10 -0700 (PDT)
Received: from bobo.ibm.com (193-116-90-211.tpgi.com.au. [193.116.90.211])
        by smtp.gmail.com with ESMTPSA id m9sm9502345pgt.65.2021.04.11.18.49.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Apr 2021 18:49:10 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Paul Mackerras <paulus@ozlabs.org>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Daniel Axtens <dja@axtens.net>
Subject: [PATCH v1 06/12] KVM: PPC: Book3S HV: Remove redundant mtspr PSPB
Date:   Mon, 12 Apr 2021 11:48:39 +1000
Message-Id: <20210412014845.1517916-7-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210412014845.1517916-1-npiggin@gmail.com>
References: <20210412014845.1517916-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This SPR is set to 0 twice when exiting the guest.

Acked-by: Paul Mackerras <paulus@ozlabs.org>
Suggested-by: Fabiano Rosas <farosas@linux.ibm.com>
Reviewed-by: Daniel Axtens <dja@axtens.net>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 70c6e9c27eb7..b88df175aa76 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -3790,7 +3790,6 @@ static int kvmhv_p9_guest_entry(struct kvm_vcpu *vcpu, u64 time_limit,
 	mtspr(SPRN_DSCR, host_dscr);
 	mtspr(SPRN_TIDR, host_tidr);
 	mtspr(SPRN_IAMR, host_iamr);
-	mtspr(SPRN_PSPB, 0);
 
 	if (host_amr != vcpu->arch.amr)
 		mtspr(SPRN_AMR, host_amr);
-- 
2.23.0

