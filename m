Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F10F527323E
	for <lists+kvm-ppc@lfdr.de>; Mon, 21 Sep 2020 20:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbgIUSv2 (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Mon, 21 Sep 2020 14:51:28 -0400
Received: from smtpout1.mo804.mail-out.ovh.net ([79.137.123.220]:38347 "EHLO
        smtpout1.mo804.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726395AbgIUSv1 (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Mon, 21 Sep 2020 14:51:27 -0400
X-Greylist: delayed 386 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Sep 2020 14:51:26 EDT
Received: from mxplan5.mail.ovh.net (unknown [10.108.4.188])
        by mo804.mail-out.ovh.net (Postfix) with ESMTPS id A5CBC6408611;
        Mon, 21 Sep 2020 20:44:57 +0200 (CEST)
Received: from kaod.org (37.59.142.101) by DAG4EX1.mxp5.local (172.16.2.31)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Mon, 21 Sep
 2020 20:44:55 +0200
Authentication-Results: garm.ovh; auth=pass (GARM-101G004c259a061-5e9c-44f5-ac25-d29eae3b0f6c,
                    324B8E9709B09D78909ABC18EB833E373A4C8178) smtp.auth=clg@kaod.org
Subject: Re: [PATCH -next v2] KVM: PPC: Book3S HV: XIVE: Convert to
 DEFINE_SHOW_ATTRIBUTE
To:     Qinglang Miao <miaoqinglang@huawei.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC:     <kvm-ppc@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
References: <20200919012925.174377-1-miaoqinglang@huawei.com>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
Message-ID: <a92af837-87fe-b324-f71e-e75bd327752a@kaod.org>
Date:   Mon, 21 Sep 2020 20:44:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200919012925.174377-1-miaoqinglang@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [37.59.142.101]
X-ClientProxiedBy: DAG7EX2.mxp5.local (172.16.2.62) To DAG4EX1.mxp5.local
 (172.16.2.31)
X-Ovh-Tracer-GUID: feffce8a-ddfa-424a-ab9e-8a9452b5cc6b
X-Ovh-Tracer-Id: 17629622220225219433
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedujedruddvgddufeduucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepuffvfhfhkffffgggjggtgfhisehtkeertddtfeejnecuhfhrohhmpeevrogurhhitggpnfgvpgfiohgrthgvrhcuoegtlhhgsehkrghougdrohhrgheqnecuggftrfgrthhtvghrnhepjeekudeuudevleegudeugeekleffveeludejteffiedvledvgfekueefudehheefnecukfhppedtrddtrddtrddtpdefjedrheelrddugedvrddutddunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhpqdhouhhtpdhhvghlohepmhigphhlrghnhedrmhgrihhlrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpegtlhhgsehkrghougdrohhrghdprhgtphhtthhopehmihgrohhqihhnghhlrghngheshhhurgifvghirdgtohhm
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 9/19/20 3:29 AM, Qinglang Miao wrote:
> Use DEFINE_SHOW_ATTRIBUTE macro to simplify the code.
> 
> Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>

Reviewed-by: Cédric Le Goater <clg@kaod.org>

> ---
> v2: based on linux-next(20200917), and can be applied to
>     mainline cleanly now.
> 
>  arch/powerpc/kvm/book3s_xive_native.c | 12 +-----------
>  1 file changed, 1 insertion(+), 11 deletions(-)
> 
> diff --git a/arch/powerpc/kvm/book3s_xive_native.c b/arch/powerpc/kvm/book3s_xive_native.c
> index bdea91df1..d0c2db0e0 100644
> --- a/arch/powerpc/kvm/book3s_xive_native.c
> +++ b/arch/powerpc/kvm/book3s_xive_native.c
> @@ -1227,17 +1227,7 @@ static int xive_native_debug_show(struct seq_file *m, void *private)
>  	return 0;
>  }
>  
> -static int xive_native_debug_open(struct inode *inode, struct file *file)
> -{
> -	return single_open(file, xive_native_debug_show, inode->i_private);
> -}
> -
> -static const struct file_operations xive_native_debug_fops = {
> -	.open = xive_native_debug_open,
> -	.read = seq_read,
> -	.llseek = seq_lseek,
> -	.release = single_release,
> -};
> +DEFINE_SHOW_ATTRIBUTE(xive_native_debug);
>  
>  static void xive_native_debugfs_init(struct kvmppc_xive *xive)
>  {
> 

