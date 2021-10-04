Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A05BA421347
	for <lists+kvm-ppc@lfdr.de>; Mon,  4 Oct 2021 18:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236223AbhJDQCy (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 4 Oct 2021 12:02:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236220AbhJDQCy (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 4 Oct 2021 12:02:54 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29931C061745
        for <kvm-ppc@vger.kernel.org>; Mon,  4 Oct 2021 09:01:05 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id e7so16989826pgk.2
        for <kvm-ppc@vger.kernel.org>; Mon, 04 Oct 2021 09:01:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=c8V1scHTGZcm2Dn3vb3tzVwF9hzvzB4+HDzAd0pKgKw=;
        b=aiYXGzNBVlPfTv7k54hzq91r1IvHTkus8O/D3LEmDMQcpLt/EImKfx3ggtcXpdHyTC
         tMmYWtx7jtVbFoAFG5ogXVlbmgiTtWrj0DLnSJO0KkZjooSzN4T4bXd8XIC5bUvkoASj
         8fMtU6Zd8YfVLsn3/n3hnV5FreDIB562ug3zNTMDOwIrQPnaf9FQxjh9aUpFKBTM0ugQ
         8itwHaIwK28bcEUUVC3JJhYj1UB0LitCXI6DXi6xryv74IuM1OAd0LJfo+mY8LqsB4xs
         Tloxj6IYt/wgkzZDEuKxkxe2Ih0SSJ7ONdnR3F8kq49sHrd7NwhzBAyp01NF63fnQMGQ
         vvAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c8V1scHTGZcm2Dn3vb3tzVwF9hzvzB4+HDzAd0pKgKw=;
        b=VjDx4Pub3NDrJJA7B/Wmstx+L3LInY7aueFgYWnCfi/Vu8H/78cfh5x2wRxAmQeEMg
         s5Xrv9BXwxjLhhF7MoZ/TMu3zO2yiO+t1XseHyx0y0Se87B02F+gyYLuA0gA8FTJ4r8m
         7r6lDOze1zrIxxyEP0AalxRKHCri9IKBANRg56tW2uCPxaRQsagp3s/+Wm7IEQmknIf9
         mCF+n1VoXf0fxG8Ylvt12N4UILdBisqoQRGpaBpVsfKm6mrzl7zxFVh99H0sy3VU51Xr
         f6U2O2XmCLhCmbft1tItF1G8XYqI7f+/OKuv03uC9as+1eRm0Ji6Yt2pmewM/VyXAe9B
         cduA==
X-Gm-Message-State: AOAM531jEcQu6NNiIuzdNF5QQdVN0BSLxOvuJwAdfOxpsF8tBt/JLePd
        XvRLjHnPESFZj8uibYpRMRflWs1BwU4=
X-Google-Smtp-Source: ABdhPJxoovPXW4e7e+wAXmLw3EOYbGp5mJiVzkhts8KFSfnO0+5VqkumX0lXYQvuezeZiW4bDhYQOQ==
X-Received: by 2002:a63:200a:: with SMTP id g10mr11295120pgg.242.1633363264562;
        Mon, 04 Oct 2021 09:01:04 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (115-64-153-41.tpgi.com.au. [115.64.153.41])
        by smtp.gmail.com with ESMTPSA id 130sm15557223pfz.77.2021.10.04.09.01.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 09:01:04 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc:     Nicholas Piggin <npiggin@gmail.com>
Subject: [PATCH v3 01/52] powerpc/64s: Remove WORT SPR from POWER9/10 (take 2)
Date:   Tue,  5 Oct 2021 01:59:58 +1000
Message-Id: <20211004160049.1338837-2-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20211004160049.1338837-1-npiggin@gmail.com>
References: <20211004160049.1338837-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

This removes a missed remnant of the WORT SPR.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/platforms/powernv/idle.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/powerpc/platforms/powernv/idle.c b/arch/powerpc/platforms/powernv/idle.c
index e3ffdc8e8567..86e787502e42 100644
--- a/arch/powerpc/platforms/powernv/idle.c
+++ b/arch/powerpc/platforms/powernv/idle.c
@@ -589,7 +589,6 @@ struct p9_sprs {
 	u64 purr;
 	u64 spurr;
 	u64 dscr;
-	u64 wort;
 	u64 ciabr;
 
 	u64 mmcra;
-- 
2.23.0

