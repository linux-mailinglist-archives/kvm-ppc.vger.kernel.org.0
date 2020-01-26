Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3859A149D62
	for <lists+kvm-ppc@lfdr.de>; Sun, 26 Jan 2020 23:32:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbgAZWcB (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 26 Jan 2020 17:32:01 -0500
Received: from mail-qv1-f67.google.com ([209.85.219.67]:45929 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726144AbgAZWcB (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sun, 26 Jan 2020 17:32:01 -0500
Received: by mail-qv1-f67.google.com with SMTP id l14so3641484qvu.12
        for <kvm-ppc@vger.kernel.org>; Sun, 26 Jan 2020 14:32:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version;
        bh=dyMWRhLVIkU7C/9VDyczGrQ+BetZzNumR7xtRDUke6M=;
        b=XHIJ5TiZYqUYMeWGJNhpzH20euHR96KZqRRuQx8VVteKKKeqdXlmRjkdN8SRduRTfG
         +MwcZlYyRH7XMV7oWdYSSRVxhi2WJneRZZR/BqXypug7rhiFB0D/bM0mnIOfqqpaXJks
         tU5FF7w0WVrdR2mKD5hK/HcebY2lQRuie53sOKGyasMO/hLKMC1uyg5eNjfQVYu4Himu
         Kr9OKrw6/SXUIQGe97oG4HOMT0DBRH4W5gZj8oKwnFYAHpqzQH7TmnTPmKIWvQ/0OEYb
         Ts19lHoXpuBdtW5emM0xFWXeKLvlDXyfR9GSCdQG5C4vA/CkAPLItcBVFmq8IkqjqYL+
         IZ+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version;
        bh=dyMWRhLVIkU7C/9VDyczGrQ+BetZzNumR7xtRDUke6M=;
        b=P7bX0zHEWhzNQtpx6q1udYtGUDqmP8fqkJnz2/HLxRzAqicS8wratIPTkcZuwKWzwJ
         Lorm+nhMWLiA95OFLjF5GBDdbZKAVj5i/0YmqDfYcrPEtGGiT1EtVuksVLECXpc16h7l
         zG36kzDwakCh4S1fI2csI43HWkK42CXGaU9TJgJIhasqb5t2duBjg64G/+4gDFKf345I
         7dtK0GFgL9LFa370BNqh08NomNx3XxcfkU6Au7WqgQWsuM/ZDIxKDjGdT/dq+1rZVDam
         jL3HVP4jM3VyALHM9LXHJQGliMFK6MDC2FA3Q8Qouu1qZ6ViMZQp3tUZhRIATRto29Sx
         fRWA==
X-Gm-Message-State: APjAAAXYbc8DOoLsylyLI9+9tG/kjfUqAdxRCDheDKK6iY7hpQ1XkLs+
        Ttq1FU3cLHQH3MjyqoqzVQRnyKuZ
X-Google-Smtp-Source: APXvYqzdIBmQWzm9dYGNEX/YSBbnVPu4NVsHThzESB90/ej4DXLqVzBeezwTAEhUjiSOGLRgECJZ/w==
X-Received: by 2002:ad4:490d:: with SMTP id bh13mr7083868qvb.180.1580077919886;
        Sun, 26 Jan 2020 14:31:59 -0800 (PST)
Received: from callisto ([2601:986:200:7341:384b:df90:fb2f:c5df])
        by smtp.gmail.com with ESMTPSA id k7sm8578415qtd.79.2020.01.26.14.31.58
        for <kvm-ppc@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jan 2020 14:31:59 -0800 (PST)
From:   David Michael <fedora.dm0@gmail.com>
To:     kvm-ppc@vger.kernel.org
Subject: [PATCH] KVM: PPC: Book3S PR: Fix -Werror=return-type build failure
Date:   Sun, 26 Jan 2020 17:31:58 -0500
Message-ID: <87v9oxkfxd.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Signed-off-by: David Michael <fedora.dm0@gmail.com>
---

Hi,

I attempted to build 5.4.15 for PPC with KVM enabled using GCC 9.2.0 (on
Gentoo), and compilation fails due to no return statement in a non-void
function.

Can this fix be applied?

Thanks.

David

 arch/powerpc/kvm/book3s_pr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
index ce4fcf76e..eb86a2f26 100644
--- a/arch/powerpc/kvm/book3s_pr.c
+++ b/arch/powerpc/kvm/book3s_pr.c
@@ -2030,6 +2030,7 @@ static int kvm_vm_ioctl_get_smmu_info_pr(struct kvm *kvm,
 {
 	/* We should not get called */
 	BUG();
+	return 0;
 }
 #endif /* CONFIG_PPC64 */
 
-- 
2.21.1

