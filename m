Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC3AD353A89
	for <lists+kvm-ppc@lfdr.de>; Mon,  5 Apr 2021 03:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231826AbhDEBUZ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 4 Apr 2021 21:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231656AbhDEBUY (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 4 Apr 2021 21:20:24 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD4BCC061756
        for <kvm-ppc@vger.kernel.org>; Sun,  4 Apr 2021 18:20:14 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id g35so2418127pgg.9
        for <kvm-ppc@vger.kernel.org>; Sun, 04 Apr 2021 18:20:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2ljQ2o/1KJXmV5budvf2xHhIW20DBRLuADvMqiJ21X0=;
        b=jteegXL22i+h9UVPqzn2fKvO68awdCVK3/kmTXzoyUnBcLbviueKoFI+ypqp8rvTw3
         Q+wiC7tzAFBILyZdrXGElHnzu2vR4ujsIz1szk24wBflaorLv9Sc57jZ3fIY8ylC4LnX
         ckclJGWyS2ugmRrEJM2liYX4/0e3ILdx4973YzOEcwakKJ8abSW06w397K1P/SH6Ld90
         wZkVMRsWCh5SPnaYm4WgEhuL9rKuFyMLq+IyUDFdv210jbVe+1zcvlRM+7nvlcIud5xc
         RunY0YAzhPRN7YiyWhtnfdFB34KPQGDpjxc/dwqUjSrr9YGFXuED5iB2JA1BCaH5ZK5N
         hXnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2ljQ2o/1KJXmV5budvf2xHhIW20DBRLuADvMqiJ21X0=;
        b=i4KFz35LKWmGjEdLeID2YDSCRPkD/PiE0S0k/MJZAGTjtgC+t64lNRi9hNnVXXqulR
         sr9rthj5uqyNfDw4mYAX72+RgSKhQd4fsp3KWsKNemJ9WKrYoOU1JM39UXw2IplL39Q9
         md6PiRHguFwFeDePUH0X8U0tnej3A/+GgdMSEHXHocj/n2oyQs/ViDIa5gcLItZUIGDa
         OABwJEvu8PbNbBgAnML+5ESa9JaqU9FEOi0ssiInPUEDUwz7Yd6VVWYmrI6nH7Bq6hGP
         H2e74W1gfEnOYXI20PEzeS3U64LF+IomCZ23EFxOvorKVVJfPlGSBDasebr653Nh1OKq
         nC1w==
X-Gm-Message-State: AOAM531cddICPVgtvypDfIvzITRQ8aH9AIPMHApJ0dqS0VQZEStXIxDH
        Y7erzPpNnjN7NUF2vRHPx63TKOpAtPA3SQ==
X-Google-Smtp-Source: ABdhPJy4e6XKE8ykNm7P8y7vG58oHuwFcXPgmxUmMJ1wX3FpQZ9izeGtMahOaoXNWJTWTTcgx2o7LQ==
X-Received: by 2002:a65:6645:: with SMTP id z5mr20660659pgv.273.1617585614266;
        Sun, 04 Apr 2021 18:20:14 -0700 (PDT)
Received: from bobo.ibm.com ([1.132.215.134])
        by smtp.gmail.com with ESMTPSA id e3sm14062536pfm.43.2021.04.04.18.20.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Apr 2021 18:20:14 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH v6 04/48] KVM: PPC: Book3S HV: Prevent radix guests setting LPCR[TC]
Date:   Mon,  5 Apr 2021 11:19:04 +1000
Message-Id: <20210405011948.675354-5-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210405011948.675354-1-npiggin@gmail.com>
References: <20210405011948.675354-1-npiggin@gmail.com>
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
index daded8949a39..a6b5d79d9306 100644
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

