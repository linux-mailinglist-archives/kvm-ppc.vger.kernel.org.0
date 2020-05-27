Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59D031E36AB
	for <lists+kvm-ppc@lfdr.de>; Wed, 27 May 2020 05:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387458AbgE0DsE (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 26 May 2020 23:48:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387456AbgE0DsE (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 26 May 2020 23:48:04 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CCC1C061A0F
        for <kvm-ppc@vger.kernel.org>; Tue, 26 May 2020 20:48:04 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49Wxcb6J2Dz9sSW;
        Wed, 27 May 2020 13:47:59 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1590551281;
        bh=kI4fWu01aAN5kkMbR2omD94nPbM41iSYIq/ZpnS4LRk=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=oI5FyY7RWtkPZVcglYtyJNoptpcFbPkUcK/mFv5enSpYaU31ydlO8aaEp5dhJcFIY
         S2pDEG3XQ9M3tpJrSdT5CgIX/9Z/qsjGk3rYH8D05UNK+at8GBFgd0kC4biPCVXCy4
         0qIPceh8PPZIpN6st/yPJk+x29Cvo9Cog9UZXHFh/ZS3gpOMp0UGPjaObU8QS3vaXu
         bvQr/lKlrQ0z4SGb8ule2ebBmq+uOvhV9CpjXWufVopv2wiDX83DtP/D1uxbEb24dB
         CSPG+zFEAzeV5ZMdnA5+dFzJVHsBFjpV2+pC7rc4lzzMIMrLz1pU2iARxOc4M2pIOu
         dIF/mkwXX21yg==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Ram Pai <linuxram@us.ibm.com>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc:     aik@ozlabs.ru, andmike@linux.ibm.com, groug@kaod.org,
        sukadev@linux.vnet.ibm.com, bauerman@linux.ibm.com,
        david@gibson.dropbear.id.au, clg@kaod.org, paulus@ozlabs.org
Subject: Re: [PATCH v3] powerpc/XIVE: SVM: share the event-queue page with the Hypervisor.
In-Reply-To: <20200426072724.GB5865@oc0525413822.ibm.com>
References: <1585211927-784-1-git-send-email-linuxram@us.ibm.com> <20200426020518.GC5853@oc0525413822.ibm.com> <20200426072724.GB5865@oc0525413822.ibm.com>
Date:   Wed, 27 May 2020 13:48:23 +1000
Message-ID: <87r1v6domw.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Ram Pai <linuxram@us.ibm.com> writes:
> XIVE interrupt controller uses an Event Queue (EQ) to enqueue event
> notifications when an exception occurs. The EQ is a single memory page
> provided by the O/S defining a circular buffer, one per server and
> priority couple.
>
> On baremetal, the EQ page is configured with an OPAL call. On pseries,
> an extra hop is necessary and the guest OS uses the hcall
> H_INT_SET_QUEUE_CONFIG to configure the XIVE interrupt controller.
>
> The XIVE controller being Hypervisor privileged, it will not be allowed
> to enqueue event notifications for a Secure VM unless the EQ pages are
> shared by the Secure VM.
>
> Hypervisor/Ultravisor still requires support for the TIMA and ESB page
> fault handlers. Until this is complete, QEMU can use the emulated XIVE
> device for Secure VMs, option "kernel_irqchip=off" on the QEMU pseries
> machine.
>
> Cc: kvm-ppc@vger.kernel.org
> Cc: linuxppc-dev@lists.ozlabs.org
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Thiago Jung Bauermann <bauerman@linux.ibm.com>
> Cc: Michael Anderson <andmike@linux.ibm.com>
> Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> Cc: Alexey Kardashevskiy <aik@ozlabs.ru>
> Cc: Paul Mackerras <paulus@ozlabs.org>
> Cc: David Gibson <david@gibson.dropbear.id.au>
> Reviewed-by: Cedric Le Goater <clg@kaod.org>
> Reviewed-by: Greg Kurz <groug@kaod.org>
> Signed-off-by: Ram Pai <linuxram@us.ibm.com>
>
> v3: fix a minor semantics in description.
>     and added reviewed-by from Cedric and Greg.
> v2: better description of the patch from Cedric.
> ---

Please put the change history after the '---' break in future please, I
had to fix this up manually.

cheers
