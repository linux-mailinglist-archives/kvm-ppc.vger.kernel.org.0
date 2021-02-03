Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF2430D8FA
	for <lists+kvm-ppc@lfdr.de>; Wed,  3 Feb 2021 12:42:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234440AbhBCLmJ (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Wed, 3 Feb 2021 06:42:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234091AbhBCLkz (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Wed, 3 Feb 2021 06:40:55 -0500
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAE78C0613ED;
        Wed,  3 Feb 2021 03:40:14 -0800 (PST)
Received: by ozlabs.org (Postfix, from userid 1034)
        id 4DW0950ZLHz9vDV; Wed,  3 Feb 2021 22:40:08 +1100 (AEDT)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Paul Mackerras <paulus@samba.org>
Cc:     linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org
In-Reply-To: <74461a99fa1466f361532ca794ca0753be3d9f86.1611038044.git.christophe.leroy@csgroup.eu>
References: <74461a99fa1466f361532ca794ca0753be3d9f86.1611038044.git.christophe.leroy@csgroup.eu>
Subject: Re: [PATCH] powerpc/kvm: Force selection of CONFIG_PPC_FPU
Message-Id: <161235200600.1516112.11309702624334183045.b4-ty@ellerman.id.au>
Date:   Wed,  3 Feb 2021 22:40:08 +1100 (AEDT)
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Tue, 19 Jan 2021 06:36:52 +0000 (UTC), Christophe Leroy wrote:
> book3s/32 kvm is designed with the assumption that
> an FPU is always present.
> 
> Force selection of FPU support in the kernel when
> build KVM.

Applied to powerpc/next.

[1/1] powerpc/kvm: Force selection of CONFIG_PPC_FPU
      https://git.kernel.org/powerpc/c/27f699579b64dbf27caf31e5c0eac567ec0aa8b8

cheers
