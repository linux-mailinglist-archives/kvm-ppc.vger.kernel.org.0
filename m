Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8D511A5F38
	for <lists+kvm-ppc@lfdr.de>; Sun, 12 Apr 2020 17:45:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727011AbgDLPpa (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sun, 12 Apr 2020 11:45:30 -0400
Received: from mout.gmx.net ([212.227.17.21]:42493 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726818AbgDLPpa (ORCPT <rfc822;kvm-ppc@vger.kernel.org>);
        Sun, 12 Apr 2020 11:45:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1586706324;
        bh=Ozo3Pc+S3y/l2oIB0mqBuzQkGUe1bcJdHUx4viCHUBo=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=B4SxjzeZ2Ll+UJqAsNnGYmHVoNs7jquH7NdyI1yBIcQmhk3hwyno7tJy0k0P0XAZm
         i3D0+Rv3VZIc7OoKAz8B5zBLhOCikqbWzf9RJlsnOteOINsXMFyqmzC+S109hAOuGD
         hVWl3AplEbu4fua6DRFHYwjXvvc8FjGdH+4KCKl8=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([82.19.195.159]) by mail.gmx.com
 (mrgmx104 [212.227.17.174]) with ESMTPSA (Nemesis) id
 1MmlTC-1ixuAX3jOw-00jqWo; Sun, 12 Apr 2020 17:45:24 +0200
From:   Alex Dewar <alex.dewar@gmx.co.uk>
To:     Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Cc:     Alex Dewar <alex.dewar@gmx.co.uk>
Subject: [PATCH] KVM: PPC: Book3S: Remove unneeded NULL check before kfree()
Date:   Sun, 12 Apr 2020 16:45:09 +0100
Message-Id: <20200412154510.36496-1-alex.dewar@gmx.co.uk>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:zvL24rS43N3XslrqBtPvrvM5md1EmfOJKzhOuGBfpkdurmKL1sy
 uTI3dwu+5jue0RbfeTpwSienBHxg8f8T3xXFOQLLczXuLOaoONOFEHKMYK2NLTSgSwLm7VA
 vPUpyMYOVgqJbwZXqSP4pW2KOvNV69AGK3HL1VFG+GVx2I55airIC82U+LZtruRyUGAVd9f
 Axncb1CsQHTVM9/rg3zow==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:mS3sETiRlb4=:G9c88SfyOlwhRW67sgdigT
 mK9Xc0CCQpjZgPCIFUXJDTVV3oWMXVKNTrAKcuDIxrk7J4nKiZpKHpZwwW8ZHoG/5ucNe34gT
 68mYlQNNvq3AQFigV2lGKiE2xLR629TntbKayBNaaxLu2OOQIHez/4LIGbn13P3dXPA2zFRdv
 h3HizeE8vHr6wN3+yBj+kzR/AEqem7kbnKrJAm5VAkISdiB8d6oAdygv/K5rQ4TeZS6zOafuA
 0MoaymEBdh8NYKIm3mZWVG/Ci5pkeGyTaZ6oBa5JVU2g4IRqb4QN+2gOkABaeZRixjn6Ed1Yi
 Lv3wmRxGH+vjQP5TpM7Hz2cA72HnH3QRRFtbi9K73V/tBgq+ZCvPA1LbN0Om8cQ66BLGwyrEu
 a1q4GosjhzebhYndZ/DoKN3JcLpV2DrShpD50aUn8V8Q1uDLSRfg0XcI8T7Osh+OHzUNjHQjt
 cXThgmPAeZ7uRvivanAjTB2LevnxyutAprklH6P5RyWcUHYQU66432mB4XJNEaq2TlysmEXm/
 T3DWOWSmnxdAPnG4mVjJxh3d7LG2WT5wwr1aWmE+R4vbHhIJtObWhgkN0BW595p8WdnqvYu+t
 zZ8dQ2eFSFBDnQN9Jxqjp8+qlM6UrbEteiDDfhH+fTV80pY/k9JvU29ga6ZGBc8WkS0jwHXF4
 Xw39HOcqZMzx1zrtWJPm/aqqmsIhFA0yg7V3FPr6VAldq4U7tdIYyiXmc//2xoAYJFvG2zkWN
 6yat7VxiSgTvnhPpREeh9p3nLWknWMsL4S1Zb160cz5MBC2sMbc+ECOtfShj/1fonklbjg19t
 WJN7J8IeVyNubvD47znU9ggc7R1gYdxnZ0Ew3BYAfk4yfqnGWOXMDEjzI3li0vdvoJtt9LypT
 e0rYZJpk1yMPO3JzQfOV2AmLc/GTd66EONQjKoqqEakLJ8wEpD14ynyC+bey1pZjiNz6hMRhx
 oxy580iSpMcCXp0sS54q2+KuovwpqBe3S3QN1IKjsYm7MejO/DyWVhp+sNHqoSJFDq/JCYOEA
 o6GQr5SiZX4q/J7esGbeCHMTkNnWKxLEWpawA2rdi22TJKEVh18G6tfFxrBXL3HG9gw+z/CdH
 Ag37WpQk7nO2UfNFfoH0OE+bTcFhoKexi7S5kTUKbCsZlSlu+YewR46FGQj3rQCD8gx4X6SqB
 OQO0WqtR5s/361G64CZBw/tMLAYvYBxLSTNgRo4c40tvRDotgybadOto+M4DcA/jJGzV3buQ3
 HMqLQ+XM7kvnsw4DI
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

kfree() already checks for NULL arguments, so this check is reduntant.
Remove it.

Signed-off-by: Alex Dewar <alex.dewar@gmx.co.uk>
=2D--
 arch/powerpc/kvm/book3s_hv_nested.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s=
_hv_nested.c
index dc97e5be76f61..cad324312040b 100644
=2D-- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -1416,8 +1416,7 @@ static long int __kvmhv_nested_page_fault(struct kvm=
_run *run,
 	rmapp =3D &memslot->arch.rmap[gfn - memslot->base_gfn];
 	ret =3D kvmppc_create_pte(kvm, gp->shadow_pgtable, pte, n_gpa, level,
 				mmu_seq, gp->shadow_lpid, rmapp, &n_rmap);
-	if (n_rmap)
-		kfree(n_rmap);
+	kfree(n_rmap);
 	if (ret =3D=3D -EAGAIN)
 		ret =3D RESUME_GUEST;	/* Let the guest try again */

=2D-
2.26.0

