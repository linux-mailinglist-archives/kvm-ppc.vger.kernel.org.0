Return-Path: <kvm-ppc-owner@vger.kernel.org>
X-Original-To: lists+kvm-ppc@lfdr.de
Delivered-To: lists+kvm-ppc@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8E8D370776
	for <lists+kvm-ppc@lfdr.de>; Sat,  1 May 2021 15:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232136AbhEAN5V (ORCPT <rfc822;lists+kvm-ppc@lfdr.de>);
        Sat, 1 May 2021 09:57:21 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43436 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232107AbhEAN5V (ORCPT
        <rfc822;kvm-ppc@vger.kernel.org>); Sat, 1 May 2021 09:57:21 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 141DXOEH043051;
        Sat, 1 May 2021 09:56:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=zfHDntymIWxlMHIRQDwwFhACh84asPFqu9RpJfxBHps=;
 b=n7rQN3weXvrCKFBt6ElPWi7qHx5eLAktVxRyy5J4kIKMD6i/fV75C+BH8x/fewMuQYxT
 9gLw8Z+gxUNSiJVm0ZjaH59EM7L5g56Jq85i69icBcFM/3oKM/27xz6d9na5rbEoJni1
 54lcCw+e8tFXQT+VypEaJDEQahJthdRcpLUwzMx2C7cRSTNQF8PVs4RgcveNc4ePFGdr
 Sk71s/3EFhlaDw3ebOM0iDG/9QKM5YqjiuDbOVtqpCTASOVfduwaAxHcdsZgaXGDsZJq
 +VzuwDzqK6kj/HbSULbzVM2IRor06S2ONLJ9BMp5OEAOvdG0d9i3yTJE3uKCPaEX/HiK +w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38979e8ums-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 01 May 2021 09:56:04 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 141DXxci047260;
        Sat, 1 May 2021 09:56:03 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38979e8um9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 01 May 2021 09:56:03 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 141DrPv9012695;
        Sat, 1 May 2021 13:56:01 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma02fra.de.ibm.com with ESMTP id 388xm882f0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 01 May 2021 13:56:01 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 141DtwQI53412284
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 1 May 2021 13:55:58 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6A670A405F;
        Sat,  1 May 2021 13:55:58 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 45A05A4054;
        Sat,  1 May 2021 13:55:53 +0000 (GMT)
Received: from [9.85.73.140] (unknown [9.85.73.140])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat,  1 May 2021 13:55:53 +0000 (GMT)
Subject: Re: [PATCH v4 0/3] nvdimm: Enable sync-dax property for nvdimm
To:     Dan Williams <dan.j.williams@intel.com>,
        Shivaprasad G Bhat <sbhat@linux.ibm.com>
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        Greg Kurz <groug@kaod.org>, qemu-ppc@nongnu.org,
        Eduardo Habkost <ehabkost@redhat.com>,
        marcel.apfelbaum@gmail.com, "Michael S. Tsirkin" <mst@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        peter.maydell@linaro.org, Eric Blake <eblake@redhat.com>,
        qemu-arm@nongnu.org, richard.henderson@linaro.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Haozhong Zhang <haozhong.zhang@intel.com>,
        shameerali.kolothum.thodi@huawei.com, kwangwoo.lee@sk.com,
        Markus Armbruster <armbru@redhat.com>,
        Qemu Developers <qemu-devel@nongnu.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        kvm-ppc@vger.kernel.org, shivaprasadbhat@gmail.com,
        bharata@linux.vnet.ibm.com
References: <161966810162.652.13723419108625443430.stgit@17be908f7c1c>
 <CAPcyv4gwkyDBG7EZOth-kcZR8Fb+RgGXY=Y9vbuHXAz3PAnLVw@mail.gmail.com>
From:   "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Message-ID: <5d70bf0e-290f-405a-f525-7b4710408332@linux.ibm.com>
Date:   Sat, 1 May 2021 19:25:52 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CAPcyv4gwkyDBG7EZOth-kcZR8Fb+RgGXY=Y9vbuHXAz3PAnLVw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 9Gawgb4RCDulWYDsGhHOAhxANDP54XpS
X-Proofpoint-GUID: uxCnoSiDh3NYfGBrFgcCF0DOw-3ZgAqh
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-01_07:2021-04-30,2021-05-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0 clxscore=1015
 mlxlogscore=999 impostorscore=0 mlxscore=0 priorityscore=1501
 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2105010096
Precedence: bulk
List-ID: <kvm-ppc.vger.kernel.org>
X-Mailing-List: kvm-ppc@vger.kernel.org

On 5/1/21 12:44 AM, Dan Williams wrote:
> Some corrections to terminology confusion below...

.......

> 
>> file on the host in case of file backed v-nvdimms. This is addressed by
>> virtio-pmem in case of x86_64 by making explicit flushes translating to
>> fsync at qemu.
> 
> Note that virtio-pmem was a proposal for a specific optimization of
> allowing guests to share page cache. The virtio-pmem approach is not
> to be confused with actual persistent memory.
> 

.....

>>
>> A new device property sync-dax is added to the nvdimm device. When the
>> sync-dax is 'writeback'(default for PPC), device property
>> "hcall-flush-required" is set, and the guest makes hcall H_SCM_FLUSH
>> requesting for an explicit flush.
> 
> I'm not sure "sync-dax" is a suitable name for the property of the
> guest persistent memory. There is no requirement that the
> memory-backend file for a guest be a dax-capable file. It's also
> implementation specific what hypercall needs to be invoked for a given
> occurrence of "sync-dax". What does that map to on non-PPC platforms
> for example? It seems to me that an "nvdimm" device presents the
> synchronous usage model and a whole other device type implements an
> async-hypercall setup that the guest happens to service with its
> nvdimm stack, but it's not an "nvdimm" anymore at that point.
> 

What is attempted here is to use the same guest driver papr_scm.ko 
support the usecase of sharing page cache from the host instead of 
depending on a new guest driver virtio-pmem. This also try to correctly 
indicate to the guest that an usage like

-object memory-backend-file,id=memnvdimm1,mem-path=file_name
-device nvdimm,memdev=memnvdimm1

correctly indicate to the guest that we are indeed sharing page cache 
and not really emulating a persistent memory.

W.r.t non ppc platforms, it was discussed earlier and one of the 
suggestion there was to mark that as "unsafe".

Any suggestion for an alternate property name than "sync-dax"?

>> sync-dax is "unsafe" on all other platforms(x86, ARM) and old pseries machines
>> prior to 5.2 on PPC. sync-dax="writeback" on ARM and x86_64 is prevented
>> now as the flush semantics are unimplemented.
> 
> "sync-dax" has no meaning on its own, I think this needs an explicit
> mechanism to convey both the "not-sync" property *and* the callback
> method, it shouldn't be inferred by arch type.

Won't a non-sync property imply that guest needs to do a callback to 
ensure persistence? Hence they are related?


-aneesh
