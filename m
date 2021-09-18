Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE85F410702
	for <lists+kvm-ppc@lfdr.de>; Sat, 18 Sep 2021 16:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237779AbhIROXZ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 18 Sep 2021 10:23:25 -0400
Received: from mout.gmx.net ([212.227.17.22]:59955 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237771AbhIROXY (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Sat, 18 Sep 2021 10:23:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1631974912;
        bh=UmWycZcizNYid4Z+392DMeF7EKIyi4qx+X3CFcO1uDE=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=OHL5tT3y1TiXx0wkB4k4slkZMZI8KDCqbWKc5Q/EfYtvF6NluuoyY9yoJP4YD9gPc
         kOiKCdeyfrg9M6eb9R1PUYhsu/qy6vcNmHvC2Wa4VzgxCcC+a7IG1JciPyJ+vYHapK
         AR+DjUc4Kjgwl5XEUFwoiAawV1qbTBW0/nG7t5pM=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([79.150.72.99]) by mail.gmx.net
 (mrgmx105 [212.227.17.174]) with ESMTPSA (Nemesis) id
 1MdebB-1n0O0n1DxB-00ZjGv; Sat, 18 Sep 2021 16:21:52 +0200
From:   Len Baker <len.baker@gmx.com>
To:     Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc:     Len Baker <len.baker@gmx.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Kees Cook <keescook@chromium.org>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-hardening@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: PPC: Replace zero-length array with flexible array member
Date:   Sat, 18 Sep 2021 16:21:38 +0200
Message-Id: <20210918142138.17709-1-len.baker@gmx.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:nUjxkWAcJOBgMwjffXAt1QuuDOCIXUU/JKmzX9iUDs9pGqz2aHN
 98GDDCSWE9bq+l3Sk5BPYQ5vXYhDBd6i6m9oBE/LNW0YxvO/oLjzioqf/Ji0uzBVOm9chr0
 LL9bRwvN7Fce6JyKqT87QUtYysU10VZEQcZZKM2WuxjcBrS1kJvveJZIa+QYFSTgKVzdzcF
 5QICgt5PO1IAWzYmd7a8Q==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:RM7jumJIPRc=:iV3Dwa2P7AD02q/3KO68IT
 BDzSVfG1ioBkwhrb+6qgNASCHxUj9Q/aArb1XlOug0eTZo7EX0tS/9NcbcL0gFVq7ZiK7juec
 aw+TghlsV9LQa5Ab4H5yeHGk0H6nj6B8NbQ2TstFwNlbxh2MqxJjrfMPNXTad7dxB8cZJPdN1
 igLcjxvmZjs/JmZxWWMzf2z2WY87Q9L4+b5ssB9aMIqj8TcNWZfHTpL1O9y5XmxwGfqPMMtdV
 lTxgVnjIhym06uO7OUfYZWIJVHEU7sFRH0yYPBLA6XJzmLPbq+LXlw0eQ9P1Ho6ogRHG2DS3c
 0JZKvyMZ7Gi9aqlxb8hQj5WyfDWAMTjYXCR8j3YFRAJ1WRJ0UyRKctaAwZSYEnmjYVGJDhQ19
 dPPt152wY9NjQBc3Hn7UgUhXHcSb70hIxNxQHRB+foCmSGwCQwsiGfJ9aZi+PSspzri3kEJW8
 i1thsYq8MTvOW3OLDv1iqHVDMni5wJIwKZqqWDhIWovfesZZ5k4DIF9QWkvW7z6P+ovABo5Wd
 j5HiWNZxxqdBZA1mBxyxe5hglT1H15Z+9v2JuWw7Yd/ATfvksdQjMZ/7HpsJ2TrNxF2twTMay
 s4yaFIj6/SBsngxuQ52uPAbxM9hCp3Il0g+9wBzE0HX3QAw+fNosh/2fM9N9D07T79yQMevCv
 QRWygqOq+PS7QU3vcJE+9PD2DpIMC8jr5n6pVK80AxxV2yK1lbLmV4MLFhwYn63Wo7REVNSTX
 g0NCghfK9b8jA0runYKHxOf4whbKHtsPf4lFYYNSDjdIfnkJuAsPu55RB4gB6evPW7rgxE6os
 uka2MC208rgCXyYKnQeWPakWWEC1WXveod36ovFxvraYU4GEK1dRFAKK5wPIruIwJQBptcCVj
 0Zf7vmXOTwGKA9T5AxPsMfaP5V1XR95fvMV73zHAwfuW+8LSgIfCepvfXh+GMYPoOQ683DsxF
 4PmOqPwM8OS038ga1mnPs/aQhfat5tzpxxDHsjplerHiZ9I51+aXdsjmGza1VVjut2rFfV2Fu
 KxL08FdYrJDx/nxab6C/N+Ux0B18NAs1Z60J9YoO7dRbx1vMlqSwskF4hBxXACceg/mH/t7yq
 o/7JJ0W4gKEMJg=
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

There is a regular need in the kernel to provide a way to declare having
a dynamically sized set of trailing elements in a structure. Kernel code
should always use "flexible array members" [1] for these cases. The
older style of one-element or zero-length arrays should no longer be
used[2].

Also, make use of the struct_size() helper in kzalloc().

[1] https://en.wikipedia.org/wiki/Flexible_array_member
[2] https://www.kernel.org/doc/html/latest/process/deprecated.html#zero-le=
ngth-and-one-element-arrays

Signed-off-by: Len Baker <len.baker@gmx.com>
=2D--
 arch/powerpc/include/asm/kvm_host.h | 2 +-
 arch/powerpc/kvm/book3s_64_vio.c    | 3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/as=
m/kvm_host.h
index 080a7feb7731..3aed653373a5 100644
=2D-- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -190,7 +190,7 @@ struct kvmppc_spapr_tce_table {
 	u64 size;		/* window size in pages */
 	struct list_head iommu_tables;
 	struct mutex alloc_lock;
-	struct page *pages[0];
+	struct page *pages[];
 };

 /* XICS components, defined in book3s_xics.c */
diff --git a/arch/powerpc/kvm/book3s_64_vio.c b/arch/powerpc/kvm/book3s_64=
_vio.c
index 6365087f3160..d42b4b6d4a79 100644
=2D-- a/arch/powerpc/kvm/book3s_64_vio.c
+++ b/arch/powerpc/kvm/book3s_64_vio.c
@@ -295,8 +295,7 @@ long kvm_vm_ioctl_create_spapr_tce(struct kvm *kvm,
 		return ret;

 	ret =3D -ENOMEM;
-	stt =3D kzalloc(sizeof(*stt) + npages * sizeof(struct page *),
-		      GFP_KERNEL);
+	stt =3D kzalloc(struct_size(stt, pages, npages), GFP_KERNEL);
 	if (!stt)
 		goto fail_acct;

=2D-
2.25.1

