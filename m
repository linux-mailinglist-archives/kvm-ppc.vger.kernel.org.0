Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 268F6274DB1
	for <lists+kvm-ppc@lfdr.de>; Wed, 23 Sep 2020 02:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727036AbgIWALc (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 22 Sep 2020 20:11:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727017AbgIWAL2 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 22 Sep 2020 20:11:28 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3E68C0613D2
        for <kvm-ppc@vger.kernel.org>; Tue, 22 Sep 2020 17:11:27 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1003)
        id 4Bwz9m5k2Rz9sTg; Wed, 23 Sep 2020 10:11:24 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1600819884; bh=zpg+PBUfeJ7GI3Gz66qYPvlYKR/QNsHAQJk+f2ycHTM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ft7brIP1rvFIR4NTmNsJKzMfXV/89YfNorLxZNlXAM6KmlKaM7W9wyGGSrRejyent
         hGPBgJ5wgrV4+1+ZsGf0ATuFH+qbWk2KJo8wQ55trRHmqUIJddBrWmVXaRvr8rswaB
         5Qu1qoSeMzNasAuEtpDGgAChHH29TUCLVDNrohxWvpZPtMMHQMavzYDT3jHlykaCti
         +8wYSgtTZRf6rcGOCmVOAzlWxkK1pNjcgR5KCKSIBZFQ0UWtyisEQDajmfFkDk36AL
         W7phA3GAObn8S/xZcWn2ZFUt6nxQXC5k3PDqYNWPVD4zh93d11bCnv3QiGtPTBJyyj
         YA+e/ut9cgDeA==
Date:   Wed, 23 Sep 2020 10:10:20 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Greg Kurz <groug@kaod.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, trivial@kernel.org
Subject: Re: [PATCH] KVM: PPC: Don't return -ENOTSUPP to userspace in ioctls
Message-ID: <20200923001020.GF531519@thinks.paulus.ozlabs.org>
References: <159982162511.459323.13495475646618845164.stgit@bahia.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159982162511.459323.13495475646618845164.stgit@bahia.lan>
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Fri, Sep 11, 2020 at 12:53:45PM +0200, Greg Kurz wrote:
> ENOTSUPP is a linux only thingy, the value of which is unknown to
> userspace, not to be confused with ENOTSUP which linux maps to
> EOPNOTSUPP, as permitted by POSIX [1]:
> 
> [EOPNOTSUPP]
> Operation not supported on socket. The type of socket (address family
> or protocol) does not support the requested operation. A conforming
> implementation may assign the same values for [EOPNOTSUPP] and [ENOTSUP].
> 
> Return -EOPNOTSUPP instead of -ENOTSUPP for the following ioctls:
> - KVM_GET_FPU for Book3s and BookE
> - KVM_SET_FPU for Book3s and BookE
> - KVM_GET_DIRTY_LOG for BookE
> 
> This doesn't affect QEMU which doesn't call the KVM_GET_FPU and
> KVM_SET_FPU ioctls on POWER anyway since they are not supported,
> and _buggily_ ignores anything but -EPERM for KVM_GET_DIRTY_LOG.
> 
> [1] https://pubs.opengroup.org/onlinepubs/9699919799/functions/V2_chap02.html
> 
> Signed-off-by: Greg Kurz <groug@kaod.org>

Thanks, applied.

Paul.
