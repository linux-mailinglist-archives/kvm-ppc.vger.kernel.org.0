Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E17ED227968
	for <lists+kvm-ppc@lfdr.de>; Tue, 21 Jul 2020 09:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbgGUHXM (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Tue, 21 Jul 2020 03:23:12 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45090 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725984AbgGUHXM (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Tue, 21 Jul 2020 03:23:12 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06L74nLE122069;
        Tue, 21 Jul 2020 03:23:01 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32dhpryeue-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jul 2020 03:23:01 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06L7L94h031502;
        Tue, 21 Jul 2020 07:22:58 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 32brq7kjvu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Jul 2020 07:22:58 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06L7MuvO53936306
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jul 2020 07:22:56 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 06BB911C054;
        Tue, 21 Jul 2020 07:22:56 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9656711C058;
        Tue, 21 Jul 2020 07:22:55 +0000 (GMT)
Received: from pomme.local (unknown [9.145.36.105])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 21 Jul 2020 07:22:55 +0000 (GMT)
Subject: Re: [RFC PATCH] powerpc/pseries/svm: capture instruction faulting on
 MMIO access, in sprg0 register
To:     Segher Boessenkool <segher@kernel.crashing.org>
Cc:     aik@ozlabs.ru, Ram Pai <linuxram@us.ibm.com>,
        kvm-ppc@vger.kernel.org, bharata@linux.ibm.com,
        sathnaga@linux.vnet.ibm.com, sukadev@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org, bauerman@linux.ibm.com,
        david@gibson.dropbear.id.au
References: <1594888333-9370-1-git-send-email-linuxram@us.ibm.com>
 <18e3bcee-8a3a-bd13-c995-8e4168471f74@linux.ibm.com>
 <20200720201041.GM30544@gate.crashing.org>
 <20200720202452.GN30544@gate.crashing.org>
From:   Laurent Dufour <ldufour@linux.ibm.com>
Message-ID: <5d912506-5834-db1a-60a1-1ccb213ff37a@linux.ibm.com>
Date:   Tue, 21 Jul 2020 09:22:55 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200720202452.GN30544@gate.crashing.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-21_02:2020-07-21,2020-07-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 spamscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 clxscore=1011 impostorscore=0 bulkscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007210048
Sender: kvm-ppc-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

Le 20/07/2020 à 22:24, Segher Boessenkool a écrit :
> On Mon, Jul 20, 2020 at 03:10:41PM -0500, Segher Boessenkool wrote:
>> On Mon, Jul 20, 2020 at 11:39:56AM +0200, Laurent Dufour wrote:
>>> Le 16/07/2020 à 10:32, Ram Pai a écrit :
>>>> +	if (is_secure_guest()) {					\
>>>> +		__asm__ __volatile__("mfsprg0 %3;"			\
>>>> +				"lnia %2;"				\
>>>> +				"ld %2,12(%2);"				\
>>>> +				"mtsprg0 %2;"				\
>>>> +				"sync;"					\
>>>> +				#insn" %0,%y1;"				\
>>>> +				"twi 0,%0,0;"				\
>>>> +				"isync;"				\
>>>> +				"mtsprg0 %3"				\
>>>> +			: "=r" (ret)					\
>>>> +			: "Z" (*addr), "r" (0), "r" (0)			\
>>>
>>> I'm wondering if SPRG0 is restored to its original value.
>>> You're using the same register (r0) for parameters 2 and 3, so when doing
>>> lnia %2, you're overwriting the SPRG0 value you saved in r0 just earlier.
>>
>> It is putting the value 0 in the registers the compiler chooses for
>> operands 2 and 3.  But operand 3 is written, while the asm says it is an
>> input.  It needs an earlyclobber as well.

Oh nice, I was not aware that compiler may choose registers this way.
Good to know, thanks for the explanation.

>>> It may be clearer to use explicit registers for %2 and %3 and to mark them
>>> as modified for the compiler.
>>
>> That is not a good idea, imnsho.
> 
> (The explicit register number part, I mean; operand 2 should be an
> output as well, yes.)

Sure if the compiler can choose the registers that's far better.

Cheers,
Laurent.
