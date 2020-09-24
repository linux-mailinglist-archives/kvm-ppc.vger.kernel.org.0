Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B599A2776D2
	for <lists+kvm-ppc@lfdr.de>; Thu, 24 Sep 2020 18:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbgIXQhT (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Thu, 24 Sep 2020 12:37:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726458AbgIXQhT (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Thu, 24 Sep 2020 12:37:19 -0400
Received: from ms.lwn.net (ms.lwn.net [IPv6:2600:3c01:e000:3a1::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0496C0613CE;
        Thu, 24 Sep 2020 09:37:19 -0700 (PDT)
Received: from lwn.net (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 09BCF750;
        Thu, 24 Sep 2020 16:37:18 +0000 (UTC)
Date:   Thu, 24 Sep 2020 10:37:16 -0600
From:   Jonathan Corbet <corbet@lwn.net>
To:     sathnaga@linux.vnet.ibm.com
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH V2] Doc: admin-guide: Add entry for kvm_cma_resv_ratio
 kernel param
Message-ID: <20200924103716.551ba462@lwn.net>
In-Reply-To: <20200921090220.14981-1-sathnaga@linux.vnet.ibm.com>
References: <20200921090220.14981-1-sathnaga@linux.vnet.ibm.com>
Organization: LWN.net
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On Mon, 21 Sep 2020 14:32:20 +0530
sathnaga@linux.vnet.ibm.com wrote:

> From: Satheesh Rajendran <sathnaga@linux.vnet.ibm.com>
> 
> Add document entry for kvm_cma_resv_ratio kernel param which
> is used to alter the KVM contiguous memory allocation percentage
> for hash pagetable allocation used by hash mode PowerPC KVM guests.
> 
> Cc: linux-kernel@vger.kernel.org
> Cc: kvm-ppc@vger.kernel.org
> Cc: linuxppc-dev@lists.ozlabs.org
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Satheesh Rajendran <sathnaga@linux.vnet.ibm.com>
> ---
> 
> V2: 
> Addressed review comments from Randy.
> 
> V1: https://lkml.org/lkml/2020/9/16/72

Applied, thanks.

jon
