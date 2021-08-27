Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E541A3F99E1
	for <lists+kvm-ppc@lfdr.de>; Fri, 27 Aug 2021 15:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245334AbhH0NXh (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Fri, 27 Aug 2021 09:23:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245304AbhH0NXb (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Fri, 27 Aug 2021 09:23:31 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB488C0612A6
        for <kvm-ppc@vger.kernel.org>; Fri, 27 Aug 2021 06:22:30 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Gx0kX2MvGz9t56;
        Fri, 27 Aug 2021 23:22:28 +1000 (AEST)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     Fabiano Rosas <farosas@linux.ibm.com>, kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, npiggin@gmail.com,
        christophe.leroy@c-s.fr
In-Reply-To: <20210805212616.2641017-1-farosas@linux.ibm.com>
References: <20210805212616.2641017-1-farosas@linux.ibm.com>
Subject: Re: [PATCH v2 0/3] KVM: PPC: Book3S HV: kvmhv_copy_tofrom_guest_radix changes
Message-Id: <163007015492.52768.12349053667840423308.b4-ty@ellerman.id.au>
Date:   Fri, 27 Aug 2021 23:15:54 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Thu, 5 Aug 2021 18:26:13 -0300, Fabiano Rosas wrote:
> This series contains the fix for __kvmhv_copy_tofrom_guest_radix plus
> a couple of changes.
> 
> - Patch 1: The fix itself. I thought a smaller fix upfront would be
>            better to facilitate any backports.
> 
> - Patch 2: Adds a sanity check to the low level function. Since the
>            hcall API already enforces that the effective address must
>            be on quadrant 0, moving the checks from the high level
>            function would only add overhead to the hcall path, so I
>            opted for a lightweight check at the low level.
> 
> [...]

Applied to powerpc/next.

[1/3] KVM: PPC: Book3S HV: Fix copy_tofrom_guest routines
      https://git.kernel.org/powerpc/c/5d7d6dac8fe99ed59eee2300e4a03370f94d5222
[2/3] KVM: PPC: Book3S HV: Add sanity check to copy_tofrom_guest
      https://git.kernel.org/powerpc/c/c232461c0c3b0aca637f0d7658a7f5d0bb393a4e
[3/3] KVM: PPC: Book3S HV: Stop exporting symbols from book3s_64_mmu_radix
      https://git.kernel.org/powerpc/c/0eb596f1e6103ebe122792a425b88c5dc21c4087

cheers
