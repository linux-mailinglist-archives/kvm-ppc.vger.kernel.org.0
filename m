Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4AD33250BB
	for <lists+kvm-ppc@lfdr.de>; Thu, 25 Feb 2021 14:48:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbhBYNrx (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 25 Feb 2021 08:47:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230467AbhBYNrw (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 25 Feb 2021 08:47:52 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29653C061756
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Feb 2021 05:47:12 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id l2so3826937pgb.1
        for <kvm-ppc@vger.kernel.org>; Thu, 25 Feb 2021 05:47:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5WGq83w4nIFDwUXoN/x8ZP7+yYqxduj9t3wxP04w6lk=;
        b=Vv7+ddpkzgRhh9YE/LxLdBIQv0wC/AEbSC/bFbZXXuaa04hFdzuuivvmoimJ1F8RgM
         rURFyGBMf3CY46OvGP3qV/6CE2gdfRA25GbmWoxe+FozAoLGbgB9fp16C9oCNU/33VdL
         wj+pt8WStmbUIeAIBonVDS5qxfDUh6GHHnPDyDQDN0TaryzBgAVzyezFz9T+qIIWBE1C
         0/YmFmkKiuwDSSS6/GqRocgRctogoEVWVwQCzxjfax7PfSgfIyMV8sdSBo3x0LntDxE9
         533fO0ezxc+9TEb2vvdEBYzmomcIVNAIO5Sxov/zf6pNYPvKFGeOEiooEgpV5r3oxz7m
         GaTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5WGq83w4nIFDwUXoN/x8ZP7+yYqxduj9t3wxP04w6lk=;
        b=ZkLT2evREu3h+mA/DGp8vG9OI+zge4cU6gAoDhLUzcsTNpAkskSaU4sa8Z2oMfRduZ
         SvDU3fCTfIlbdwdLG9cg6nhuEFgvlnbfC4shyLOuKkZdrFmxP7R18w3b/uuiDOXVvnXy
         jOSmi83grF/OENJSwEGLBnSHmTlqkUwGTJWq1ifGcRGGByndXmHjcjc7ASa8U4PlCV4L
         bmBV4UcOI77LtJbzrd4pvU/mDpjm0C8nwTzFu4x9+DJK/XNQ7GCj/+sTGdpWDOdlVRtf
         /EbNGHKj8Xfx/GNRGSq2IwUH/yQzYABTGHAceVATwm75M7ZwNg4shktbegERqrpLEk5s
         gaDA==
X-Gm-Message-State: AOAM530hyW+25DFMkliXkSdxOktao/SSJQcFN++GKBL/3H/ysLxOKZa5
        gj9KJXmX90wZG0eJeKFExwrB8R6l+q8=
X-Google-Smtp-Source: ABdhPJy4stBtzZ4ef0AuMSuecUMTr51LG8sJdPr/qiCdGBmQ4BlF+bu+U1GlqC0zzjjuUvXb7e/S3w==
X-Received: by 2002:a62:25c7:0:b029:156:72a3:b0c0 with SMTP id l190-20020a6225c70000b029015672a3b0c0mr3312010pfl.59.1614260831378;
        Thu, 25 Feb 2021 05:47:11 -0800 (PST)
Received: from bobo.ibm.com (58-6-239-121.tpgi.com.au. [58.6.239.121])
        by smtp.gmail.com with ESMTPSA id a9sm5925868pjq.17.2021.02.25.05.47.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 05:47:10 -0800 (PST)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 02/37] KVM: PPC: Book3S HV: Fix CONFIG_SPAPR_TCE_IOMMU=n default hcalls
Date:   Thu, 25 Feb 2021 23:46:17 +1000
Message-Id: <20210225134652.2127648-3-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20210225134652.2127648-1-npiggin@gmail.com>
References: <20210225134652.2127648-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This config option causes the warning in init_default_hcalls to fire
because the TCE handlers are in the default hcall list but not
implemented.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/kvm/book3s_hv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 13bad6bf4c95..895090636295 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -5369,8 +5369,10 @@ static unsigned int default_hcall_list[] = {
 	H_READ,
 	H_PROTECT,
 	H_BULK_REMOVE,
+#ifdef CONFIG_SPAPR_TCE_IOMMU
 	H_GET_TCE,
 	H_PUT_TCE,
+#endif
 	H_SET_DABR,
 	H_SET_XDABR,
 	H_CEDE,
-- 
2.23.0

