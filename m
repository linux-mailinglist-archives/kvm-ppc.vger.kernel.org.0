Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD0EE532842
	for <lists+kvm-ppc@lfdr.de>; Tue, 24 May 2022 12:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236388AbiEXKyC (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 24 May 2022 06:54:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236386AbiEXKyB (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 24 May 2022 06:54:01 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 705F74ECD6
        for <kvm-ppc@vger.kernel.org>; Tue, 24 May 2022 03:53:58 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4L6rfW54fHz4xbd;
        Tue, 24 May 2022 20:53:55 +1000 (AEST)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>, linuxppc-dev@lists.ozlabs.org
Cc:     Fabiano Rosas <farosas@linux.ibm.com>,
        Frederic Barrat <fbarrat@linux.ibm.com>,
        kvm-ppc@vger.kernel.org
In-Reply-To: <20220506053755.3820702-1-aik@ozlabs.ru>
References: <20220506053755.3820702-1-aik@ozlabs.ru>
Subject: Re: [PATCH kernel v2] KVM: PPC: Book3s: Retire H_PUT_TCE/etc real mode handlers
Message-Id: <165338951112.1711920.752815379112806107.b4-ty@ellerman.id.au>
Date:   Tue, 24 May 2022 20:51:51 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Fri, 6 May 2022 15:37:55 +1000, Alexey Kardashevskiy wrote:
> LoPAPR defines guest visible IOMMU with hypercalls to use it -
> H_PUT_TCE/etc. Implemented first on POWER7 where hypercalls would trap
> in the KVM in the real mode (with MMU off). The problem with the real mode
> is some memory is not available and some API usage crashed the host but
> enabling MMU was an expensive operation.
> 
> The problems with the real mode handlers are:
> 1. Occasionally these cannot complete the request so the code is
> copied+modified to work in the virtual mode, very little is shared;
> 2. The real mode handlers have to be linked into vmlinux to work;
> 3. An exception in real mode immediately reboots the machine.
> 
> [...]

Applied to powerpc/topic/ppc-kvm.

[1/1] KVM: PPC: Book3s: Retire H_PUT_TCE/etc real mode handlers
      https://git.kernel.org/powerpc/c/cad32d9d42e8e6a659786f8a730b221a9fbee227

cheers
